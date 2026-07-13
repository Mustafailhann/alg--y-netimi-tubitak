using Microsoft.EntityFrameworkCore;
using RealityLens.Application.CQRS.Interfaces;
using RealityLens.Domain.Enums;
using System;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace RealityLens.Application.CQRS.Queries.TrainingSessions;

public record GetCurrentQuestionQuery(Guid TrainingSessionId) : IQuery<StudentQuestionDto?>;

public record StudentQuestionDto(
    Guid Id,
    Guid GroundTruthId,
    string Title,
    string FileUrl,
    string MediaType,
    int Order);

public class GetCurrentQuestionQueryHandler : IQueryHandler<GetCurrentQuestionQuery, StudentQuestionDto?>
{
    private readonly IApplicationDbContext _context;

    public GetCurrentQuestionQueryHandler(IApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<StudentQuestionDto?> HandleAsync(GetCurrentQuestionQuery request, CancellationToken cancellationToken)
    {
        var session = await _context.TrainingSessions
            .FirstOrDefaultAsync(x => x.Id == request.TrainingSessionId, cancellationToken);

        if (session == null || session.Status != TrainingSessionStatus.Active)
            return null;

        var currentItem = await _context.TrainingItems
            .Where(ti => ti.TrainingPackId == session.TrainingPackId)
            .OrderBy(ti => ti.OrderIndex)
            .Skip(session.CurrentQuestionIndex)
            .Include(ti => ti.Assessment)
                .ThenInclude(a => a.Media)
            .Include(ti => ti.Assessment)
                .ThenInclude(a => a.GroundTruth)
            .FirstOrDefaultAsync(cancellationToken);

        if (currentItem?.Assessment?.Media == null || currentItem.Assessment.GroundTruth == null)
            return null;

        string mediaType = currentItem.Assessment.Media.MimeType.StartsWith("image", StringComparison.OrdinalIgnoreCase) 
            ? "Image" 
            : "Video";

        return new StudentQuestionDto(
            currentItem.Id,
            currentItem.Assessment.GroundTruth.Id,
            currentItem.Assessment.Question,
            currentItem.Assessment.Media.StoragePath,
            mediaType,
            currentItem.OrderIndex
        );
    }
}
