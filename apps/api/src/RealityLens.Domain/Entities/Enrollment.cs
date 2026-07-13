using RealityLens.Domain.Common;
using System;

namespace RealityLens.Domain.Entities;

[Obsolete("Deprecated in favor of Sprint 6 Training Domain entities. Scheduled for removal in a future cleanup sprint.")]
public class Enrollment : BaseEntity
{
    public Guid StudentId { get; private set; }
    public User Student { get; private set; } = null!;

    public Guid ClassId { get; private set; }
    public Class Class { get; private set; } = null!;

    public DateTime EnrolledAt { get; private set; }
    public DateTime? UnenrolledAt { get; private set; }

    private Enrollment() { } // EF Core

    public Enrollment(Guid studentId, Guid classId)
    {
        StudentId = studentId;
        ClassId = classId;
        EnrolledAt = DateTime.UtcNow;
    }

    public void CloseEnrollment()
    {
        UnenrolledAt = DateTime.UtcNow;
        UpdateTimestamp();
    }
}
