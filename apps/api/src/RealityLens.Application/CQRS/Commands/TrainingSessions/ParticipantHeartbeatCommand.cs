using Microsoft.EntityFrameworkCore;
using RealityLens.Application.CQRS.Interfaces;
using System;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace RealityLens.Application.CQRS.Commands.TrainingSessions;

public record ParticipantHeartbeatCommand(Guid TrainingSessionId, Guid ParticipantId) : ICommand;

public class ParticipantHeartbeatCommandHandler : ICommandHandler<ParticipantHeartbeatCommand>
{
    private readonly IApplicationDbContext _context;

    public ParticipantHeartbeatCommandHandler(IApplicationDbContext context)
    {
        _context = context;
    }

    public async Task HandleAsync(ParticipantHeartbeatCommand request, CancellationToken cancellationToken)
    {
        var session = await _context.TrainingSessions
            .Include(x => x.Participants)
            .FirstOrDefaultAsync(x => x.Id == request.TrainingSessionId, cancellationToken);

        if (session == null)
            throw new Exception("Session not found");

        var participant = session.Participants.FirstOrDefault(p => p.Id == request.ParticipantId);
        if (participant != null)
        {
            participant.RecordHeartbeat();
            await _context.SaveChangesAsync(cancellationToken);
        }
    }
}
