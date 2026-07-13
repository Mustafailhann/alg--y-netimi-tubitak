using System;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using RealityLens.Application.CQRS.Interfaces;
using RealityLens.Domain.Enums;

using System.Linq;

namespace RealityLens.Application.CQRS.Queries.TrainingSessions;

public record TrainingSessionDetailDto(Guid Id, Guid TrainingPackId, string JoinCode, TrainingSessionStatus Status, int ParticipantCount, int? TimeLimitMinutes, bool RandomQuestionOrder, bool AllowRetry, bool ShowImmediateFeedback, bool LeaderboardEnabled, bool CanvasRequired, int? MaximumAttempts, DateTime CreatedAt, Guid Version);

public record GetTrainingSessionByIdQuery(Guid SessionId, Guid TeacherId) : IQuery<TrainingSessionDetailDto?>;

public class GetTrainingSessionByIdQueryHandler : IQueryHandler<GetTrainingSessionByIdQuery, TrainingSessionDetailDto?>
{
    private readonly IApplicationDbContext _context;

    public GetTrainingSessionByIdQueryHandler(IApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<TrainingSessionDetailDto?> HandleAsync(GetTrainingSessionByIdQuery query, CancellationToken cancellationToken = default)
    {
        return await _context.TrainingSessions
            .AsNoTracking()
            .Where(x => x.Id == query.SessionId && x.CreatedBy == query.TeacherId)
            .Select(x => new TrainingSessionDetailDto(
                x.Id, 
                x.TrainingPackId, 
                x.JoinCode.Value, 
                x.Status, 
                x.ParticipantCount,
                x.Configuration.TimeLimitMinutes,
                x.Configuration.RandomQuestionOrder,
                x.Configuration.AllowRetry,
                x.Configuration.ShowImmediateFeedback,
                x.Configuration.LeaderboardEnabled,
                x.Configuration.CanvasRequired,
                x.Configuration.MaximumAttempts,
                x.CreatedAt,
                x.Version))
            .FirstOrDefaultAsync(cancellationToken);
    }
}
