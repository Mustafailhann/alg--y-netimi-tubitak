using System;
using RealityLens.Domain.Enums;

namespace RealityLens.Application.DTOs;

public class AssessmentListResponse
{
    public Guid Id { get; set; }
    public Guid MediaId { get; set; }
    public string Question { get; set; } = null!;
    public AssessmentStatus Status { get; set; }
}

public class AssessmentDetailResponse
{
    public Guid Id { get; set; }
    public Guid MediaId { get; set; }
    public string Question { get; set; } = null!;
    public AssessmentStatus Status { get; set; }
    public GroundTruthResponse? GroundTruth { get; set; }
}

public class CreateAssessmentRequest
{
    public Guid MediaId { get; set; }
    public string Question { get; set; } = null!;
}

public class UpdateAssessmentRequest
{
    public string Question { get; set; } = null!;
}
