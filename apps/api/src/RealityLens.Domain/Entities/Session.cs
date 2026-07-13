using RealityLens.Domain.Common;
using RealityLens.Domain.Enums;
using System;

namespace RealityLens.Domain.Entities;

[Obsolete("Deprecated in favor of Sprint 6 Training Domain entities. Scheduled for removal in a future cleanup sprint.")]
public class Session : BaseEntity
{
    public Guid StudentId { get; private set; }
    public User Student { get; private set; } = null!;

    public Guid AssessmentId { get; private set; }
    public Assessment Assessment { get; private set; } = null!;

    public SessionStatus Status { get; private set; }
    public DateTime StartedAt { get; private set; }
    public DateTime? SubmittedAt { get; private set; }

    public Answer? Answer { get; private set; }
    public Evaluation? Evaluation { get; private set; }

    private Session() { } // EF Core

    public Session(Guid studentId, Guid assessmentId)
    {
        StudentId = studentId;
        AssessmentId = assessmentId;
        Status = SessionStatus.NotStarted;
        StartedAt = DateTime.UtcNow;
    }

    public void Start()
    {
        Status = SessionStatus.InProgress;
        UpdateTimestamp();
    }

    public void Submit()
    {
        Status = SessionStatus.Submitted;
        SubmittedAt = DateTime.UtcNow;
        UpdateTimestamp();
    }
}
