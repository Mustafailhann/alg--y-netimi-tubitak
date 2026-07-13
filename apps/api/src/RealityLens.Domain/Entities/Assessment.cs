using RealityLens.Domain.Common;
using RealityLens.Domain.Enums;
using System;
using System.Collections.Generic;

namespace RealityLens.Domain.Entities;

public class Assessment : BaseEntity
{
    public Guid MediaId { get; private set; }
    public Media Media { get; private set; } = null!;

    public string Question { get; private set; } = null!;
    public AssessmentStatus Status { get; private set; }

    public GroundTruth? GroundTruth { get; private set; }

    public IReadOnlyCollection<Assignment> Assignments => _assignments.AsReadOnly();
    private readonly List<Assignment> _assignments = new();

    public IReadOnlyCollection<Session> Sessions => _sessions.AsReadOnly();
    private readonly List<Session> _sessions = new();

    private Assessment() { } // EF Core

    public Assessment(Guid mediaId, string question)
    {
        MediaId = mediaId;
        Question = question;
        Status = AssessmentStatus.Draft;
    }

    public void MarkAsReady()
    {
        if (Status == AssessmentStatus.Published || Status == AssessmentStatus.Archived)
            throw new InvalidOperationException("Cannot change status from Published or Archived.");

        if (MediaId == Guid.Empty)
            throw new InvalidOperationException("Media is required to mark as ready.");

        if (GroundTruth == null)
            throw new InvalidOperationException("Classification (Ground Truth) is not defined.");

        if (GroundTruth.Judgment == Judgment.Manipulated && !GroundTruth.Annotations.Any())
            throw new InvalidOperationException("Manipulated assessment must have at least one GroundTruth (Annotation) defined.");

        Status = AssessmentStatus.Ready;
        UpdateTimestamp();
    }

    public void Publish()
    {
        if (Status != AssessmentStatus.Ready)
            throw new InvalidOperationException("Assessment must be Ready before publishing.");
            
        Status = AssessmentStatus.Published;
        UpdateTimestamp();
    }

    public void UpdateQuestion(string question)
    {
        if (Status == AssessmentStatus.Published || Status == AssessmentStatus.Archived)
            throw new InvalidOperationException("Cannot update an Assessment that is already Published or Archived.");

        Question = question;
        UpdateTimestamp();
    }

    public void Archive()
    {
        Status = AssessmentStatus.Archived;
        UpdateTimestamp();
    }
}
