using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using RealityLens.Application.CQRS.Interfaces;
using RealityLens.Domain.Enums;

using System.Linq;

namespace RealityLens.Application.CQRS.Queries.TrainingSessions;

public record ParticipantDto(Guid Id, string StudentIdentifier, DateTime JoinedAt, int ProgressPercentage, int Score, ConnectionStatus ConnectionStatus, DateTime LastSeen);

public record GetTrainingSessionParticipantsQuery(Guid SessionId, Guid TeacherId) : IQuery<IEnumerable<ParticipantDto>>;

public class GetTrainingSessionParticipantsQueryHandler : IQueryHandler<GetTrainingSessionParticipantsQuery, IEnumerable<ParticipantDto>>
{
    private readonly IApplicationDbContext _context;

    public GetTrainingSessionParticipantsQueryHandler(IApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<IEnumerable<ParticipantDto>> HandleAsync(GetTrainingSessionParticipantsQuery query, CancellationToken cancellationToken = default)
    {
        // Check authorization
        var sessionExistsAndAuthorized = await _context.TrainingSessions
            .AnyAsync(x => x.Id == query.SessionId && x.CreatedBy == query.TeacherId, cancellationToken);
            
        if (!sessionExistsAndAuthorized)
            return Enumerable.Empty<ParticipantDto>();

        var participants = await _context.Participants
            .AsNoTracking()
            .Where(x => x.TrainingSessionId == query.SessionId)
            .OrderByDescending(x => x.Score)
            .ThenByDescending(x => x.ProgressPercentage)
            .ToListAsync(cancellationToken);

        var utcNow = DateTime.UtcNow;

        return participants.Select(x => {
            var status = x.ConnectionStatus;
            if (status == ConnectionStatus.Online && x.LastHeartbeatAt.HasValue && (utcNow - x.LastHeartbeatAt.Value).TotalSeconds > 30)
            {
                status = ConnectionStatus.Offline;
            }
            return new ParticipantDto(x.Id, x.StudentIdentifier, x.JoinedAt, x.ProgressPercentage, x.Score, status, x.LastSeen);
        });
    }
}
