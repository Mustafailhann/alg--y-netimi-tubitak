using System;

namespace RealityLens.Domain.Common;

public abstract class BaseEntity
{
    public Guid Id { get; protected set; }
    public DateTime CreatedAt { get; protected set; }
    public DateTime UpdatedAt { get; protected set; }

    public bool IsDeleted { get; protected set; }
    public Guid Version { get; protected set; }

    protected BaseEntity()
    {
        Id = Guid.NewGuid();
        CreatedAt = DateTime.UtcNow;
        UpdatedAt = DateTime.UtcNow;
        IsDeleted = false;
        Version = Guid.NewGuid();
    }

    public void UpdateTimestamp()
    {
        UpdatedAt = DateTime.UtcNow;
        Version = Guid.NewGuid();
    }
    
    public void Delete()
    {
        IsDeleted = true;
        UpdateTimestamp();
    }
}
