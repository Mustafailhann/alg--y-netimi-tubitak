using Microsoft.EntityFrameworkCore;
using RealityLens.Application.CQRS.Interfaces;
using RealityLens.Domain.Enums;
using System;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.Extensions.Logging;

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
    private readonly Microsoft.Extensions.Logging.ILogger<GetCurrentQuestionQueryHandler> _logger;

    public GetCurrentQuestionQueryHandler(IApplicationDbContext context, Microsoft.Extensions.Logging.ILogger<GetCurrentQuestionQueryHandler> logger)
    {
        _context = context;
        _logger = logger;
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

        if (currentItem == null)
        {
            _logger.LogWarning("GetCurrentQuestion: currentItem is null for Session {SessionId}, Index {Index}", session.Id, session.CurrentQuestionIndex);
            return null;
        }

        if (currentItem.Assessment == null)
        {
            _logger.LogWarning("GetCurrentQuestion: Assessment is null for Session {SessionId}, ItemId {ItemId}", session.Id, currentItem.Id);
            return null;
        }

        if (currentItem.Assessment.Media == null || currentItem.Assessment.GroundTruth == null)
        {
            _logger.LogWarning("GetCurrentQuestion: Media or GroundTruth is null for Session {SessionId}, AssessmentId {AssessmentId}", session.Id, currentItem.Assessment.Id);
            return null;
        }

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
