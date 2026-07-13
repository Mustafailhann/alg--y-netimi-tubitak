using RealityLens.Domain.Common;
using System.Collections.Generic;

namespace RealityLens.Domain.Entities;

public class Role : BaseEntity
{
    public string Name { get; private set; } = null!;

    public IReadOnlyCollection<User> Users => _users.AsReadOnly();
    private readonly List<User> _users = new();

    private Role() { } // EF Core

    public Role(string name)
    {
        Name = name;
    }
}
