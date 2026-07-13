using Microsoft.EntityFrameworkCore;
using RealityLens.Application.CQRS.Interfaces;
using System;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace RealityLens.Application.CQRS.Queries.TrainingSessions;

public record GetSessionResultsQuery(Guid TrainingSessionId, Guid ParticipantId) : IQuery<StudentSessionResultDto?>;

public record StudentSessionResultDto(
    int TotalQuestions,
    int AnsweredQuestions,
    int CorrectCount,
    int IncorrectCount,
    long AverageResponseTimeMs,
    int Score,
    int ProgressPercentage);

public class GetSessionResultsQueryHandler : IQueryHandler<GetSessionResultsQuery, StudentSessionResultDto?>
{
    private readonly IApplicationDbContext _context;

    public GetSessionResultsQueryHandler(IApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<StudentSessionResultDto?> HandleAsync(GetSessionResultsQuery request, CancellationToken cancellationToken)
    {
        var session = await _context.TrainingSessions
            .Include(x => x.Participants)
            .FirstOrDefaultAsync(x => x.Id == request.TrainingSessionId, cancellationToken);

        if (session == null)
            return null;

        var participant = session.Participants.FirstOrDefault(p => p.Id == request.ParticipantId);
        if (participant == null)
            return null;

        var answers = await _context.ParticipantAnswers
            .Where(a => a.ParticipantId == request.ParticipantId && a.TrainingSessionId == request.TrainingSessionId)
            .ToListAsync(cancellationToken);

        var totalQuestions = await _context.TrainingItems
            .CountAsync(ti => ti.TrainingPackId == session.TrainingPackId, cancellationToken);

        int answeredCount = answers.Count;
        int correctCount = answers.Count(a => a.IsCorrect);
        int incorrectCount = answeredCount - correctCount;
        long avgTime = answeredCount > 0 ? (long)answers.Average(a => a.TimeTakenMilliseconds) : 0;

        return new StudentSessionResultDto(
            totalQuestions,
            answeredCount,
            correctCount,
            incorrectCount,
            avgTime,
            participant.Score,
            participant.ProgressPercentage
        );
    }
}
