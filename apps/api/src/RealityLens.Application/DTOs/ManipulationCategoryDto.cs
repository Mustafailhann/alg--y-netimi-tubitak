using System;

namespace RealityLens.Application.DTOs;

public class CategoryResponse
{
    public Guid Id { get; set; }
    public string Name { get; set; } = null!;
    public string Description { get; set; } = null!;
}

public class CreateCategoryRequest
{
    public string Name { get; set; } = null!;
    public string Description { get; set; } = null!;
}

public class UpdateCategoryRequest
{
    public string Name { get; set; } = null!;
    public string Description { get; set; } = null!;
}
