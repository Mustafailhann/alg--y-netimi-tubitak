using Microsoft.EntityFrameworkCore;
using RealityLens.Application.CQRS.Interfaces;
using RealityLens.Application.DTOs;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.Json;
using System.Threading;
using System.Threading.Tasks;

namespace RealityLens.Application.CQRS.Queries.TrainingSessions;

public record GetQuestionReviewQuery(Guid TrainingSessionId, Guid ParticipantId, Guid TrainingItemId) : IQuery<QuestionReviewDto?>;

public record QuestionReviewDto(
    List<AnnotationResponse> TeacherAnnotations,
    List<AnnotationResponse> StudentAnnotations,
    double MediaWidth,
    double MediaHeight);

public class GetQuestionReviewQueryHandler : IQueryHandler<GetQuestionReviewQuery, QuestionReviewDto?>
{
    private readonly IApplicationDbContext _context;

    public GetQuestionReviewQueryHandler(IApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<QuestionReviewDto?> HandleAsync(GetQuestionReviewQuery request, CancellationToken cancellationToken)
    {
        // Ensure the session and item exist, and the participant belongs to the session
        var session = await _context.TrainingSessions
            .FirstOrDefaultAsync(x => x.Id == request.TrainingSessionId, cancellationToken);

        if (session == null) return null;

        var trainingItem = await _context.TrainingItems
            .Include(ti => ti.Assessment)
                .ThenInclude(a => a.GroundTruth)
            .Include(ti => ti.Assessment)
                .ThenInclude(a => a.Media)
            .FirstOrDefaultAsync(ti => ti.Id == request.TrainingItemId && ti.TrainingPackId == session.TrainingPackId, cancellationToken);

        if (trainingItem == null) return null;

        var answer = await _context.ParticipantAnswers
            .FirstOrDefaultAsync(a => a.ParticipantId == request.ParticipantId && a.TrainingItemId == request.TrainingItemId && a.TrainingSessionId == request.TrainingSessionId, cancellationToken);

        var pack = await _context.TrainingPacks.FindAsync(session.TrainingPackId);
        if (pack == null) return null;

        var teacherAnnotations = new List<AnnotationResponse>();
        var studentAnnotations = new List<AnnotationResponse>();

        // Fetch Teacher annotations
        if (trainingItem.Assessment?.GroundTruth != null)
        {
            var gtId = trainingItem.Assessment.GroundTruth.Id;
            var tAnns = await _context.Annotations
                .Where(a => a.GroundTruthId == gtId && a.ParticipantAnswerId == null)
                .ToListAsync(cancellationToken);
            
            teacherAnnotations = tAnns.Select(a => new AnnotationResponse
            {
                Id = a.Id,
                CreatedBy = a.CreatedBy,
                Type = a.Type,
                Geometry = JsonDocument.Parse(a.GeometryData).RootElement,
                StartSeconds = a.StartSeconds,
                EndSeconds = a.EndSeconds,
                CreatedAt = a.CreatedAt,
                UpdatedAt = a.UpdatedAt
            }).ToList();
        }

        // Fetch Student annotations
        if (answer != null)
        {
            var sAnns = await _context.Annotations
                .Where(a => a.ParticipantAnswerId == answer.Id)
                .ToListAsync(cancellationToken);

            studentAnnotations = sAnns.Select(a => new AnnotationResponse
            {
                Id = a.Id,
                CreatedBy = a.CreatedBy,
                Type = a.Type,
                Geometry = JsonDocument.Parse(a.GeometryData).RootElement,
                StartSeconds = a.StartSeconds,
                EndSeconds = a.EndSeconds,
                CreatedAt = a.CreatedAt,
                UpdatedAt = a.UpdatedAt
            }).ToList();
        }

        double mediaWidth = trainingItem.Assessment?.Media?.Width ?? 800.0;
        double mediaHeight = trainingItem.Assessment?.Media?.Height ?? 600.0;

        return new QuestionReviewDto(teacherAnnotations, studentAnnotations, mediaWidth, mediaHeight);
    }
}
