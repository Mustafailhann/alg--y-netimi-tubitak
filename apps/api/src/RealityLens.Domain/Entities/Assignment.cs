using RealityLens.Domain.Common;
using RealityLens.Domain.Enums;
using System;

namespace RealityLens.Domain.Entities;

[Obsolete("Deprecated in favor of Sprint 6 Training Domain entities. Scheduled for removal in a future cleanup sprint.")]
public class Assignment : BaseEntity
{
    public Guid AssessmentId { get; private set; }
    public Assessment Assessment { get; private set; } = null!;

    public Guid AssignedByTeacherId { get; private set; }
    public User AssignedByTeacher { get; private set; } = null!;

    public TargetType TargetType { get; private set; }
    public Guid TargetId { get; private set; }

    public DateTime StartDate { get; private set; }
    public DateTime? EndDate { get; private set; }

    private Assignment() { } // EF Core

    public Assignment(Guid assessmentId, Guid assignedByTeacherId, TargetType targetType, Guid targetId, DateTime startDate, DateTime? endDate = null)
    {
        AssessmentId = assessmentId;
        AssignedByTeacherId = assignedByTeacherId;
        TargetType = targetType;
        TargetId = targetId;
        StartDate = startDate;
        EndDate = endDate;
    }
}
