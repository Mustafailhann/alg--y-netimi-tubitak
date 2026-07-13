using RealityLens.Domain.Common;
using RealityLens.Domain.Enums;
using System;
using System.Collections.Generic;

namespace RealityLens.Domain.Entities;

public class GroundTruth : BaseEntity
{
    public Guid AssessmentId { get; private set; }
    public Assessment Assessment { get; private set; } = null!;

    public Judgment Judgment { get; private set; }
    
    public Guid? ManipulationCategoryId { get; private set; }
    public ManipulationCategory? ManipulationCategory { get; private set; }

    public string Reason { get; private set; } = null!;
    public GroundTruthStatus Status { get; private set; }

    public IReadOnlyCollection<Annotation> Annotations => _annotations.AsReadOnly();
    private readonly List<Annotation> _annotations = new();

    private GroundTruth() { } // EF Core

    public GroundTruth(Guid assessmentId, Judgment judgment, Guid? manipulationCategoryId, string reason)
    {
        if (judgment == Judgment.Manipulated && !manipulationCategoryId.HasValue)
        {
            throw new ArgumentException("ManipulationCategory is required when judgment is Manipulated.");
        }
        if (judgment == Judgment.Real && manipulationCategoryId.HasValue)
        {
            throw new ArgumentException("ManipulationCategory must be null when judgment is Real.");
        }

        AssessmentId = assessmentId;
        Judgment = judgment;
        ManipulationCategoryId = manipulationCategoryId;
        Reason = reason;
        Status = GroundTruthStatus.Draft;
    }

    public void Validate()
    {
        Status = GroundTruthStatus.Validated;
        UpdateTimestamp();
    }

    public void Update(Judgment judgment, Guid? manipulationCategoryId, string reason)
    {
        if (judgment == Judgment.Manipulated && !manipulationCategoryId.HasValue)
        {
            throw new ArgumentException("ManipulationCategory is required when judgment is Manipulated.");
        }
        if (judgment == Judgment.Real && manipulationCategoryId.HasValue)
        {
            throw new ArgumentException("ManipulationCategory must be null when judgment is Real.");
        }

        Judgment = judgment;
        ManipulationCategoryId = manipulationCategoryId;
        Reason = reason;
        UpdateTimestamp();
    }

    public void Lock()
    {
        Status = GroundTruthStatus.Locked;
        UpdateTimestamp();
    }
}
