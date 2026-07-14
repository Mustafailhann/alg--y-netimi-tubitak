using Microsoft.EntityFrameworkCore;
using RealityLens.Application.CQRS.Interfaces;
using RealityLens.Domain.Enums;
using System;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace RealityLens.Application.CQRS.Queries.TrainingSessions;

public record GetStudentSessionStateQuery(Guid TrainingSessionId, Guid ParticipantId) : IQuery<StudentSessionStateDto?>;

public record StudentSessionStateDto(
    Guid SessionId,
    string JoinCode,
    TrainingSessionStatus Status,
    int CurrentQuestionIndex,
    int TotalQuestions,
    ConnectionStatus ConnectionStatus,
    bool HasAnsweredCurrentQuestion,
    bool AutoAdvance,
    bool ShowImmediateFeedback);

public class GetStudentSessionStateQueryHandler : IQueryHandler<GetStudentSessionStateQuery, StudentSessionStateDto?>
{
    private readonly IApplicationDbContext _context;

    public GetStudentSessionStateQueryHandler(IApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<StudentSessionStateDto?> HandleAsync(GetStudentSessionStateQuery request, CancellationToken cancellationToken)
    {
        var session = await _context.TrainingSessions
            .Include(x => x.Participants)
            .FirstOrDefaultAsync(x => x.Id == request.TrainingSessionId, cancellationToken);

        if (session == null)
            return null;

        var participant = session.Participants.FirstOrDefault(p => p.Id == request.ParticipantId);
        if (participant == null)
            return null;

        var totalQuestions = await _context.TrainingItems
            .CountAsync(ti => ti.TrainingPackId == session.TrainingPackId, cancellationToken);

        bool hasAnswered = false;
        
        if (session.Status == TrainingSessionStatus.Active && session.CurrentQuestionIndex < totalQuestions)
        {
            var currentItem = await _context.TrainingItems
                .Where(ti => ti.TrainingPackId == session.TrainingPackId)
                .OrderBy(ti => ti.OrderIndex)
                .Skip(session.CurrentQuestionIndex)
                .FirstOrDefaultAsync(cancellationToken);

            if (currentItem != null)
            {
                hasAnswered = await _context.ParticipantAnswers
                    .AnyAsync(a => a.ParticipantId == request.ParticipantId && a.TrainingItemId == currentItem.Id, cancellationToken);
            }
        }

        return new StudentSessionStateDto(
            session.Id,
            session.JoinCode.Value,
            session.Status,
            session.CurrentQuestionIndex,
            totalQuestions,
            participant.ConnectionStatus,
            hasAnswered,
            session.Configuration.AutoAdvance,
            session.Configuration.ShowImmediateFeedback
        );
    }
}
