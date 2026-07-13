using RealityLens.Domain.Common;
using RealityLens.Domain.Enums;
using System;
using System.Collections.Generic;

namespace RealityLens.Domain.Entities;

public class Answer : BaseEntity
{
    public Guid SessionId { get; private set; }
    public Session Session { get; private set; } = null!;

    public Judgment Judgment { get; private set; }
    
    public Guid? ManipulationCategoryId { get; private set; }
    public ManipulationCategory? ManipulationCategory { get; private set; }

    public float ConfidenceScore { get; private set; }
    public string Reason { get; private set; } = null!;

    public Guid? AnnotationId { get; private set; }

    private Answer() { } // EF Core

    public Answer(Guid sessionId, Judgment judgment, Guid? manipulationCategoryId, float confidenceScore, string reason)
    {
        if (judgment == Judgment.Manipulated && !manipulationCategoryId.HasValue)
        {
            throw new ArgumentException("ManipulationCategory is required when judgment is Manipulated.");
        }
        if (judgment == Judgment.Real && manipulationCategoryId.HasValue)
        {
            throw new ArgumentException("ManipulationCategory must be null when judgment is Real.");
        }
        if (confidenceScore < 0 || confidenceScore > 100)
        {
            throw new ArgumentException("ConfidenceScore must be between 0 and 100.");
        }

        SessionId = sessionId;
        Judgment = judgment;
        ManipulationCategoryId = manipulationCategoryId;
        ConfidenceScore = confidenceScore;
        Reason = reason;
    }
}
