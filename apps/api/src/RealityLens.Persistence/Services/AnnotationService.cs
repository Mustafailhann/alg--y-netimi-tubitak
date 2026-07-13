using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.Json;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using RealityLens.Application.DTOs;
using RealityLens.Application.Interfaces;
using RealityLens.Domain.Entities;
using RealityLens.Domain.Enums;

namespace RealityLens.Persistence.Services;

public class AnnotationService : IAnnotationService
{
    private readonly RealityLensDbContext _dbContext;
    private readonly ILogger<AnnotationService> _logger;

    public AnnotationService(RealityLensDbContext dbContext, ILogger<AnnotationService> logger)
    {
        _dbContext = dbContext;
        _logger = logger;
    }

    // ── Query ─────────────────────────────────────────────────────────────────

    public async Task<AnnotationResponse> GetByIdAsync(Guid id)
    {
        var annotation = await _dbContext.Annotations
            .AsNoTracking()
            .FirstOrDefaultAsync(a => a.Id == id);

        if (annotation is null)
            throw new KeyNotFoundException($"Annotation '{id}' not found.");

        return Map(annotation);
    }

    public async Task<IEnumerable<AnnotationResponse>> GetByGroundTruthAsync(Guid groundTruthId, Guid? userId = null)
    {
        var groundTruth = await _dbContext.GroundTruths
            .AsNoTracking()
            .Include(g => g.Annotations)
            .FirstOrDefaultAsync(g => g.Id == groundTruthId);

        if (groundTruth == null)
            throw new KeyNotFoundException($"GroundTruth '{groundTruthId}' not found.");

        IEnumerable<Annotation> annotations = groundTruth.Annotations;
        
        if (userId.HasValue)
        {
            annotations = annotations.Where(a => a.CreatedBy == userId.Value);
        }

        return annotations.Select(Map);
    }

    public async Task<IEnumerable<AnnotationResponse>> GetParticipantAnnotationAsync(Guid groundTruthId, Guid participantId)
    {
        // For MVP: returns the active/draft annotations created by this participant for this specific ground truth.
        // To avoid loading annotations from previous questions in the same session,
        // we filter out annotations that have already been tied to a ParticipantAnswer.
        
        var usedAnnotationIds = await _dbContext.Annotations
            .Where(a => a.ParticipantAnswerId != null)
            .Select(a => a.Id)
            .ToListAsync();

        var annotations = await _dbContext.Annotations
            .AsNoTracking()
            .Where(a => a.CreatedBy == participantId && a.GroundTruthId == groundTruthId && !usedAnnotationIds.Contains(a.Id))
            .ToListAsync();

        return annotations.Select(Map);
    }

    // ── Commands ─────────────────────────────────────────────────────────────

    public async Task<AnnotationResponse> CreateAsync(CreateAnnotationRequest request, Guid userId)
    {
        // Serialize geometry: JsonElement -> string (stored as JSONB)
        var geometryString = JsonSerializer.Serialize(request.Geometry);

        var annotation = new Annotation(
            type: request.Type,
            geometryData: geometryString,
            createdBy: userId,
            groundTruthId: request.GroundTruthId);

        _dbContext.Annotations.Add(annotation);

        if (request.GroundTruthId.HasValue)
        {
            var groundTruth = await _dbContext.GroundTruths.FindAsync(request.GroundTruthId.Value);
            if (groundTruth == null)
            {
                throw new KeyNotFoundException($"GroundTruth '{request.GroundTruthId.Value}' not found.");
            }
        }

        await _dbContext.SaveChangesAsync();

        return Map(annotation);
    }

    public async Task<AnnotationResponse> UpdateAsync(Guid id, UpdateAnnotationRequest request, Guid userId)
    {
        var annotation = await _dbContext.Annotations.FirstOrDefaultAsync(a => a.Id == id);

        if (annotation is null)
            throw new KeyNotFoundException($"Annotation '{id}' not found.");

        if (annotation.CreatedBy != userId)
            throw new UnauthorizedAccessException("You are not authorized to modify this annotation.");

        // Serialize geometry: JsonElement → string (stored as JSONB)
        var geometryString = JsonSerializer.Serialize(request.Geometry);

        annotation.Update(request.Type, geometryString);
        await _dbContext.SaveChangesAsync();

        return Map(annotation);
    }

    public async Task DeleteAsync(Guid id, Guid userId)
    {
        var annotation = await _dbContext.Annotations.FirstOrDefaultAsync(a => a.Id == id);

        if (annotation is null)
            throw new KeyNotFoundException($"Annotation '{id}' not found.");

        if (annotation.CreatedBy != userId)
            throw new UnauthorizedAccessException("You are not authorized to delete this annotation.");

        _dbContext.Annotations.Remove(annotation);
        await _dbContext.SaveChangesAsync();
    }

    // ── Private helpers ──────────────────────────────────────────────────────

    /// <summary>
    /// Maps a domain Annotation to a response DTO.
    /// Deserializes the stored JSONB string back to JsonElement so the API
    /// contract returns structured JSON, not a raw encoded string.
    /// </summary>
    private static AnnotationResponse Map(Annotation annotation)
    {
        JsonElement geometry;
        try
        {
            geometry = JsonSerializer.Deserialize<JsonElement>(annotation.GeometryData);
        }
        catch (JsonException)
        {
            // Stored data is malformed — return an empty object rather than
            // crashing; this should never occur if all writes go through the service.
            geometry = JsonSerializer.Deserialize<JsonElement>("{}");
        }

        return new AnnotationResponse
        {
            Id             = annotation.Id,
            CreatedBy      = annotation.CreatedBy,
            Type           = annotation.Type,
            Geometry       = geometry,
            StartSeconds   = annotation.StartSeconds,
            EndSeconds     = annotation.EndSeconds,
            CreatedAt      = annotation.CreatedAt,
            UpdatedAt      = annotation.UpdatedAt,
        };
    }

    /// <summary>
    /// Validates that all coordinates in the geometry fit within the image's
    /// pixel dimensions. Throws <see cref="InvalidOperationException"/> on violation.
    /// </summary>
    private static void ValidateBounds(
        JsonElement geometry,
        AnnotationType type,
        int imageWidth,
        int imageHeight)
    {
        switch (type)
        {
            case AnnotationType.Rectangle:
                ValidateRectangleBounds(geometry, imageWidth, imageHeight);
                break;

            case AnnotationType.Polygon:
            case AnnotationType.Brush:
                ValidatePointsBounds(geometry, imageWidth, imageHeight, type.ToString());
                break;
        }
    }

    private static void ValidateRectangleBounds(JsonElement obj, int imageWidth, int imageHeight)
    {
        var x = obj.GetProperty("x").GetDouble();
        var y = obj.GetProperty("y").GetDouble();
        var w = obj.GetProperty("width").GetDouble();
        var h = obj.GetProperty("height").GetDouble();

        if (x + w > imageWidth)
            throw new InvalidOperationException(
                $"Rectangle exceeds image width: x({x}) + width({w}) > imageWidth({imageWidth}).");

        if (y + h > imageHeight)
            throw new InvalidOperationException(
                $"Rectangle exceeds image height: y({y}) + height({h}) > imageHeight({imageHeight}).");
    }

    private static void ValidatePointsBounds(
        JsonElement obj,
        int imageWidth,
        int imageHeight,
        string shapeName)
    {
        var pointsEl = obj.GetProperty("points");
        var index = 0;

        foreach (var point in pointsEl.EnumerateArray())
        {
            var coords = point.EnumerateArray().ToArray();
            var px = coords[0].GetDouble();
            var py = coords[1].GetDouble();

            if (px > imageWidth)
                throw new InvalidOperationException(
                    $"{shapeName} point[{index}].x ({px}) exceeds image width ({imageWidth}).");

            if (py > imageHeight)
                throw new InvalidOperationException(
                    $"{shapeName} point[{index}].y ({py}) exceeds image height ({imageHeight}).");

            index++;
        }
    }
}
