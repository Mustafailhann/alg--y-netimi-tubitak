using RealityLens.Domain.Common;
using System;
using System.Collections.Generic;

namespace RealityLens.Domain.Entities;

public class User : BaseEntity
{
    public string Email { get; private set; } = null!;
    public string PasswordHash { get; private set; } = null!;
    public bool IsActive { get; private set; }
    
    public Guid RoleId { get; private set; }
    public Role Role { get; private set; } = null!;

    public IReadOnlyCollection<Class> TaughtClasses => _taughtClasses.AsReadOnly();
    private readonly List<Class> _taughtClasses = new();

    public IReadOnlyCollection<Enrollment> Enrollments => _enrollments.AsReadOnly();
    private readonly List<Enrollment> _enrollments = new();

    public IReadOnlyCollection<Session> Sessions => _sessions.AsReadOnly();
    private readonly List<Session> _sessions = new();

    private User() { } // EF Core

    public User(string email, string passwordHash, Guid roleId)
    {
        Email = email;
        PasswordHash = passwordHash;
        RoleId = roleId;
        IsActive = true;
    }

    public void Deactivate()
    {
        IsActive = false;
        UpdateTimestamp();
    }
}
