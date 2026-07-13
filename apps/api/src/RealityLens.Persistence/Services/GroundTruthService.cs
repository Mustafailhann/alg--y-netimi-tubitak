using System;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using RealityLens.Application.DTOs;
using RealityLens.Application.Interfaces;
using RealityLens.Domain.Entities;

namespace RealityLens.Persistence.Services;

public class GroundTruthService : IGroundTruthService
{
    private readonly RealityLensDbContext _dbContext;

    public GroundTruthService(RealityLensDbContext dbContext)
    {
        _dbContext = dbContext;
    }

    private static GroundTruthResponse Map(GroundTruth gt)
    {
        return new GroundTruthResponse { Id = gt.Id, AssessmentId = gt.AssessmentId, Judgment = gt.Judgment, ManipulationCategoryId = gt.ManipulationCategoryId, Reason = gt.Reason, Status = gt.Status };
    }

    public async Task<GroundTruthResponse> GetByAssessmentIdAsync(Guid assessmentId)
    {
        var gt = await _dbContext.GroundTruths.FirstOrDefaultAsync(g => g.AssessmentId == assessmentId);
        if (gt == null) throw new KeyNotFoundException("Ground Truth not found.");
        return Map(gt);
    }

    public async Task<GroundTruthResponse> CreateAsync(Guid assessmentId, CreateGroundTruthRequest request)
    {
        var assessment = await _dbContext.Assessments.FirstOrDefaultAsync(a => a.Id == assessmentId);
        if (assessment == null) throw new InvalidOperationException("Assessment does not exist.");
        if (assessment.Status == RealityLens.Domain.Enums.AssessmentStatus.Published || assessment.Status == RealityLens.Domain.Enums.AssessmentStatus.Archived)
            throw new InvalidOperationException("Cannot modify GroundTruth of a published or archived Assessment.");

        var gtExists = await _dbContext.GroundTruths.AnyAsync(g => g.AssessmentId == assessmentId);
        if (gtExists) throw new InvalidOperationException("Ground Truth already exists for this Assessment.");

        if (request.ManipulationCategoryId.HasValue)
        {
            var catExists = await _dbContext.ManipulationCategories.AnyAsync(c => c.Id == request.ManipulationCategoryId.Value);
            if (!catExists) throw new InvalidOperationException("Manipulation Category does not exist.");
        }

        var gt = new GroundTruth(assessmentId, request.Judgment, request.ManipulationCategoryId, request.Reason);
        _dbContext.GroundTruths.Add(gt);
        await _dbContext.SaveChangesAsync();

        return Map(gt);
    }

    public async Task<GroundTruthResponse> UpdateAsync(Guid assessmentId, UpdateGroundTruthRequest request)
    {
        var assessment = await _dbContext.Assessments.FirstOrDefaultAsync(a => a.Id == assessmentId);
        if (assessment != null && (assessment.Status == RealityLens.Domain.Enums.AssessmentStatus.Published || assessment.Status == RealityLens.Domain.Enums.AssessmentStatus.Archived))
            throw new InvalidOperationException("Cannot modify GroundTruth of a published or archived Assessment.");

        var gt = await _dbContext.GroundTruths.FirstOrDefaultAsync(g => g.AssessmentId == assessmentId);
        if (gt == null) throw new KeyNotFoundException("Ground Truth not found.");

        if (request.ManipulationCategoryId.HasValue)
        {
            var catExists = await _dbContext.ManipulationCategories.AnyAsync(c => c.Id == request.ManipulationCategoryId.Value);
            if (!catExists) throw new InvalidOperationException("Manipulation Category does not exist.");
        }

        gt.Update(request.Judgment, request.ManipulationCategoryId, request.Reason);

        await _dbContext.SaveChangesAsync();

        return Map(gt);
    }
}
