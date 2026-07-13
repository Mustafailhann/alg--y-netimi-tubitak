using RealityLens.Domain.Common;
using RealityLens.Domain.Enums;
using System;

namespace RealityLens.Domain.Entities;

public class ParticipantAnswer : BaseEntity, IAggregateRoot
{
    public Guid TrainingSessionId { get; private set; }
    public Guid ParticipantId { get; private set; }
    public Guid TrainingItemId { get; private set; }
    public Guid AssessmentId { get; private set; }
    
    public Judgment Judgment { get; private set; }
    
    // Temporary classification fallback, true if matches ground truth
    public bool IsCorrect { get; private set; }
    
    public IReadOnlyCollection<Annotation> Annotations => _annotations.AsReadOnly();
    private readonly List<Annotation> _annotations = new();

    // Sprint 6E placeholders
    public decimal? ClassificationScore { get; private set; }
    public decimal? LocalizationScore { get; private set; }
    public decimal? TotalScore { get; private set; }

    public DateTime SubmittedAt { get; private set; }
    public long TimeTakenMilliseconds { get; private set; }

    private ParticipantAnswer() { } // EF Core

    public ParticipantAnswer(
        Guid trainingSessionId,
        Guid participantId,
        Guid trainingItemId,
        Guid assessmentId,
        Judgment judgment,
        bool isCorrect,
        long timeTakenMilliseconds)
    {
        TrainingSessionId = trainingSessionId;
        ParticipantId = participantId;
        TrainingItemId = trainingItemId;
        AssessmentId = assessmentId;
        Judgment = judgment;
        IsCorrect = isCorrect;
        TimeTakenMilliseconds = timeTakenMilliseconds;
        SubmittedAt = DateTime.UtcNow;
    }

    public void UpdateScoring(decimal classificationScore, decimal localizationScore, decimal totalScore, bool isCorrect)
    {
        ClassificationScore = classificationScore;
        LocalizationScore = localizationScore;
        TotalScore = totalScore;
        IsCorrect = isCorrect;
    }
}
