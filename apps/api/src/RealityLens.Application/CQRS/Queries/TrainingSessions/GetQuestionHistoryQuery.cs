using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using RealityLens.Application.CQRS.Interfaces;
using RealityLens.Domain.Enums;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace RealityLens.Application.CQRS.Queries.TrainingSessions;

public record GetQuestionHistoryQuery(Guid TrainingSessionId, Guid ParticipantId) : IQuery<List<QuestionHistoryDto>>;

public record QuestionHistoryDto(
    Guid TrainingItemId,
    int OrderIndex,
    int QuestionNumber,
    Guid AssessmentId,
    Guid? GroundTruthId,
    string MediaUrl,
    Judgment? SubmittedJudgment,
    Judgment? CorrectJudgment,
    string? Reason,
    string? ManipulationCategoryName,
    decimal? ClassificationScore,
    decimal? LocalizationScore,
    decimal? LocalizationThreshold,
    bool? PassedLocalization,
    bool? IsCorrect,
    int TimeSpentSeconds,
    DateTime? SubmittedAt);

public class GetQuestionHistoryQueryHandler : IQueryHandler<GetQuestionHistoryQuery, List<QuestionHistoryDto>>
{
    private readonly IApplicationDbContext _context;
    private readonly Microsoft.Extensions.Configuration.IConfiguration _configuration;

    public GetQuestionHistoryQueryHandler(IApplicationDbContext context, Microsoft.Extensions.Configuration.IConfiguration configuration)
    {
        _context = context;
        _configuration = configuration;
    }

    public async Task<List<QuestionHistoryDto>> HandleAsync(GetQuestionHistoryQuery request, CancellationToken cancellationToken)
    {
        var session = await _context.TrainingSessions
            .FirstOrDefaultAsync(x => x.Id == request.TrainingSessionId, cancellationToken);

        if (session == null)
            return new List<QuestionHistoryDto>();

        // We only show history up to the current question index
        var pastItems = await _context.TrainingItems
            .Where(ti => ti.TrainingPackId == session.TrainingPackId && ti.OrderIndex < session.CurrentQuestionIndex)
            .OrderBy(ti => ti.OrderIndex)
            .Include(ti => ti.Assessment)
                .ThenInclude(a => a.Media)
            .Include(ti => ti.Assessment)
                .ThenInclude(a => a.GroundTruth)
                    .ThenInclude(gt => gt!.ManipulationCategory)
            .ToListAsync(cancellationToken);

        var answers = await _context.ParticipantAnswers
            .Where(a => a.ParticipantId == request.ParticipantId && a.TrainingSessionId == request.TrainingSessionId)
            .ToDictionaryAsync(a => a.TrainingItemId, cancellationToken);

        var history = new List<QuestionHistoryDto>();

        var localizationThreshold = _configuration.GetValue<decimal>("Scoring:LocalizationThreshold", 50m);

        foreach (var item in pastItems)
        {
            answers.TryGetValue(item.Id, out var answer);
            
            string mediaUrl = item.Assessment?.Media?.StoragePath ?? string.Empty;

            bool? passedLocalization = null;
            if (item.Assessment?.GroundTruth?.Judgment == Judgment.Manipulated && answer?.Judgment == Judgment.Manipulated)
            {
                passedLocalization = answer?.LocalizationScore >= localizationThreshold;
            }

            history.Add(new QuestionHistoryDto(
                item.Id,
                item.OrderIndex,
                item.OrderIndex + 1,
                item.AssessmentId,
                item.Assessment?.GroundTruth?.Id,
                mediaUrl,
                answer?.Judgment,
                item.Assessment?.GroundTruth?.Judgment,
                item.Assessment?.GroundTruth?.Reason,
                item.Assessment?.GroundTruth?.ManipulationCategory?.Name,
                answer?.ClassificationScore,
                answer?.LocalizationScore,
                localizationThreshold,
                passedLocalization,
                answer?.IsCorrect,
                (int)((answer?.TimeTakenMilliseconds ?? 0) / 1000),
                answer?.SubmittedAt
            ));
        }

        return history;
    }
}
