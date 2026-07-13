using RealityLens.Domain.Common;
using System;

namespace RealityLens.Domain.Entities;

[Obsolete("Deprecated in favor of Sprint 6 Training Domain entities. Scheduled for removal in a future cleanup sprint.")]
public class Evaluation : BaseEntity
{
    public Guid SessionId { get; private set; }
    public Session Session { get; private set; } = null!;

    public bool JudgmentMatch { get; private set; }
    public bool CategoryMatch { get; private set; }
    public float AnnotationOverlapScore { get; private set; }
    public float TotalScore { get; private set; }

    private Evaluation() { } // EF Core

    public Evaluation(Guid sessionId, bool judgmentMatch, bool categoryMatch, float annotationOverlapScore, float totalScore)
    {
        SessionId = sessionId;
        JudgmentMatch = judgmentMatch;
        CategoryMatch = categoryMatch;
        AnnotationOverlapScore = annotationOverlapScore;
        TotalScore = totalScore;
    }
}
