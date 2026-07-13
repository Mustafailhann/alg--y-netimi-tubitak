using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using RealityLens.Application.DTOs;
using RealityLens.Application.Interfaces;
using RealityLens.Domain.Entities;

namespace RealityLens.Persistence.Services;

public class AssessmentService : IAssessmentService
{
    private readonly RealityLensDbContext _dbContext;

    public AssessmentService(RealityLensDbContext dbContext)
    {
        _dbContext = dbContext;
    }

    private static AssessmentListResponse MapList(Assessment a)
    {
        return new AssessmentListResponse { Id = a.Id, MediaId = a.MediaId, Question = a.Question, Status = a.Status };
    }

    private static AssessmentDetailResponse MapDetail(Assessment a)
    {
        var gtDto = a.GroundTruth != null ? new GroundTruthResponse 
        { 
            Id = a.GroundTruth.Id, 
            AssessmentId = a.GroundTruth.AssessmentId,
            Judgment = a.GroundTruth.Judgment,
            ManipulationCategoryId = a.GroundTruth.ManipulationCategoryId,
            Reason = a.GroundTruth.Reason,
            Status = a.GroundTruth.Status
        } : null;

        return new AssessmentDetailResponse 
        { 
            Id = a.Id, 
            MediaId = a.MediaId, 
            Question = a.Question, 
            Status = a.Status, 
            GroundTruth = gtDto 
        };
    }

    public async Task<IEnumerable<AssessmentListResponse>> GetAllAsync()
    {
        var entities = await _dbContext.Assessments
            .Where(a => a.Status != RealityLens.Domain.Enums.AssessmentStatus.Archived)
            .ToListAsync();
        return entities.Select(MapList);
    }

    public async Task<AssessmentDetailResponse> GetByIdAsync(Guid id)
    {
        var a = await _dbContext.Assessments
            .Include(x => x.GroundTruth)
            .FirstOrDefaultAsync(x => x.Id == id);
            
        if (a == null || a.Status == RealityLens.Domain.Enums.AssessmentStatus.Archived) 
            throw new KeyNotFoundException("Assessment not found or archived.");

        return MapDetail(a);
    }

    public async Task<AssessmentDetailResponse> CreateAsync(CreateAssessmentRequest request)
    {
        var mediaExists = await _dbContext.Media.AnyAsync(m => m.Id == request.MediaId);
        if (!mediaExists) throw new InvalidOperationException("Media does not exist.");

        var assessment = new Assessment(request.MediaId, request.Question);
        _dbContext.Assessments.Add(assessment);
        await _dbContext.SaveChangesAsync();

        return MapDetail(assessment);
    }

    public async Task<AssessmentDetailResponse> UpdateAsync(Guid id, UpdateAssessmentRequest request)
    {
        var a = await _dbContext.Assessments.Include(x => x.GroundTruth).FirstOrDefaultAsync(x => x.Id == id);
        if (a == null) throw new KeyNotFoundException("Assessment not found.");
        if (a.Status == RealityLens.Domain.Enums.AssessmentStatus.Archived) throw new InvalidOperationException("Cannot update archived assessment.");

        a.UpdateQuestion(request.Question);

        await _dbContext.SaveChangesAsync();

        return MapDetail(a);
    }

    public async Task ArchiveAsync(Guid id)
    {
        var a = await _dbContext.Assessments.FindAsync(id);
        if (a == null) throw new KeyNotFoundException("Assessment not found.");

        a.Archive();
        await _dbContext.SaveChangesAsync();
    }

    public async Task MarkReadyAsync(Guid id)
    {
        var a = await _dbContext.Assessments
            .Include(x => x.GroundTruth)
                .ThenInclude(gt => gt!.Annotations)
            .FirstOrDefaultAsync(x => x.Id == id);
        if (a == null) throw new KeyNotFoundException("Assessment not found.");

        a.MarkAsReady();
        await _dbContext.SaveChangesAsync();
    }

    public async Task PublishAsync(Guid id)
    {
        var a = await _dbContext.Assessments.FindAsync(id);
        if (a == null) throw new KeyNotFoundException("Assessment not found.");

        a.Publish();
        await _dbContext.SaveChangesAsync();
    }
}
