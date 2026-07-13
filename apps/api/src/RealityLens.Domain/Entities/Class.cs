using RealityLens.Domain.Common;
using System;
using System.Collections.Generic;

namespace RealityLens.Domain.Entities;

[Obsolete("Deprecated in favor of Sprint 6 Training Domain entities. Scheduled for removal in a future cleanup sprint.")]
public class Class : BaseEntity
{
    public string Name { get; private set; } = null!;
    public bool IsArchived { get; private set; }

    public Guid TeacherId { get; private set; }
    public User Teacher { get; private set; } = null!;

    public IReadOnlyCollection<Enrollment> Enrollments => _enrollments.AsReadOnly();
    private readonly List<Enrollment> _enrollments = new();

    private Class() { } // EF Core

    public Class(string name, Guid teacherId)
    {
        Name = name;
        TeacherId = teacherId;
        IsArchived = false;
    }

    public void Archive()
    {
        IsArchived = true;
        UpdateTimestamp();
    }
}
