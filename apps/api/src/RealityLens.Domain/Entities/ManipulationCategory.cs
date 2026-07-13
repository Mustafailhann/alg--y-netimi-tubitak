using RealityLens.Domain.Common;

namespace RealityLens.Domain.Entities;

public class ManipulationCategory : BaseEntity
{
    public string Name { get; private set; } = null!;
    public string Description { get; private set; } = null!;

    private ManipulationCategory() { } // EF Core

    public ManipulationCategory(string name, string description)
    {
        Name = name;
        Description = description;
    }

    public void Update(string name, string description)
    {
        Name = name;
        Description = description;
        UpdateTimestamp();
    }
}
