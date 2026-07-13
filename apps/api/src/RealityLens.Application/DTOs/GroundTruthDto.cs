using System;
using RealityLens.Domain.Enums;

namespace RealityLens.Application.DTOs;

public class GroundTruthResponse
{
    public Guid Id { get; set; }
    public Guid AssessmentId { get; set; }
    public Judgment Judgment { get; set; }
    public Guid? ManipulationCategoryId { get; set; }
    public string Reason { get; set; } = null!;
    public GroundTruthStatus Status { get; set; }
}

public class CreateGroundTruthRequest
{
    public Judgment Judgment { get; set; }
    public Guid? ManipulationCategoryId { get; set; }
    public string Reason { get; set; } = null!;
}

public class UpdateGroundTruthRequest
{
    public Judgment Judgment { get; set; }
    public Guid? ManipulationCategoryId { get; set; }
    public string Reason { get; set; } = null!;
}
