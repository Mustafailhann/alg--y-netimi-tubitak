using Microsoft.EntityFrameworkCore;
using RealityLens.Application.CQRS.Interfaces;
using System;
using System.Threading;
using System.Threading.Tasks;

namespace RealityLens.Application.CQRS.Commands.TrainingSessions;

public record FinishSessionCommand(Guid TrainingSessionId, Guid TeacherId) : ICommand;

public class FinishSessionCommandHandler : ICommandHandler<FinishSessionCommand>
{
    private readonly IApplicationDbContext _context;

    public FinishSessionCommandHandler(IApplicationDbContext context)
    {
        _context = context;
    }

    public async Task HandleAsync(FinishSessionCommand request, CancellationToken cancellationToken)
    {
        var session = await _context.TrainingSessions
            .FirstOrDefaultAsync(x => x.Id == request.TrainingSessionId, cancellationToken);

        if (session == null)
            throw new Exception("Session not found");

        if (session.CreatedBy != request.TeacherId)
            throw new Exception("Unauthorized. Only the teacher who created the session can finish it.");

        session.FinishSession(request.TeacherId);

        await _context.SaveChangesAsync(cancellationToken);
    }
}
