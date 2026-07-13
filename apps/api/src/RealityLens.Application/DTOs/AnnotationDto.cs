using System;
using System.Text.Json;
using RealityLens.Domain.Enums;

namespace RealityLens.Application.DTOs;

public class AnnotationResponse
{
    public Guid Id { get; set; }
    public Guid CreatedBy { get; set; }
    public AnnotationType Type { get; set; }
    public JsonElement Geometry { get; set; }
    public float? StartSeconds { get; set; }
    public float? EndSeconds { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime UpdatedAt { get; set; }
}

public class CreateAnnotationRequest
{
    public Guid? GroundTruthId { get; set; }
    public AnnotationType Type { get; set; }
    public JsonElement Geometry { get; set; }
}

public class UpdateAnnotationRequest
{
    public AnnotationType Type { get; set; }
    public JsonElement Geometry { get; set; }
}
