using Microsoft.EntityFrameworkCore;
using RealityLens.Application.CQRS.Interfaces;
using RealityLens.Domain.Entities;
using System;
using System.Threading;
using System.Threading.Tasks;

namespace RealityLens.Application.CQRS.Commands.TrainingSessions;

public record NextQuestionCommand(Guid TrainingSessionId, Guid TeacherId) : ICommand;

public class NextQuestionCommandHandler : ICommandHandler<NextQuestionCommand>
{
    private readonly IApplicationDbContext _context;

    public NextQuestionCommandHandler(IApplicationDbContext context)
    {
        _context = context;
    }

    public async Task HandleAsync(NextQuestionCommand request, CancellationToken cancellationToken)
    {
        var session = await _context.TrainingSessions
            .FirstOrDefaultAsync(x => x.Id == request.TrainingSessionId, cancellationToken);

        if (session == null)
            throw new Exception("Session not found");

        if (session.CreatedBy != request.TeacherId)
            throw new Exception("Unauthorized. Only the teacher who created the session can advance questions.");

        var totalQuestions = await _context.TrainingItems
            .CountAsync(x => x.TrainingPackId == session.TrainingPackId, cancellationToken);

        if (session.CurrentQuestionIndex + 1 >= totalQuestions)
        {
            session.End(request.TeacherId);
        }
        else
        {
            session.NextQuestion(request.TeacherId);
        }

        await _context.SaveChangesAsync(cancellationToken);
    }
}
