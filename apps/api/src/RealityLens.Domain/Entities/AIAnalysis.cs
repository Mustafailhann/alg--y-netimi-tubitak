using RealityLens.Domain.Common;
using RealityLens.Domain.Enums;
using System;

namespace RealityLens.Domain.Entities;

public class AIAnalysis : BaseEntity
{
    public Guid MediaId { get; private set; }
    public Media Media { get; private set; } = null!;

    public string ModelIdentifier { get; private set; } = null!;
    public AnalysisStatus Status { get; private set; }
    public Judgment? Judgment { get; private set; }
    public float? ConfidenceScore { get; private set; }
    public string[]? DetectedCategories { get; private set; }
    public DateTime RequestedAt { get; private set; }
    public DateTime? CompletedAt { get; private set; }
    public string? ErrorMessage { get; private set; }

    private AIAnalysis() { } // EF Core

    public AIAnalysis(Guid mediaId, string modelIdentifier)
    {
        MediaId = mediaId;
        ModelIdentifier = modelIdentifier;
        Status = AnalysisStatus.Pending;
        RequestedAt = DateTime.UtcNow;
    }

    public void Complete(Judgment judgment, float confidenceScore, string[]? detectedCategories)
    {
        Status = AnalysisStatus.Completed;
        Judgment = judgment;
        ConfidenceScore = confidenceScore;
        DetectedCategories = detectedCategories;
        CompletedAt = DateTime.UtcNow;
        UpdateTimestamp();
    }

    public void Fail(string errorMessage)
    {
        Status = AnalysisStatus.Failed;
        ErrorMessage = errorMessage;
        CompletedAt = DateTime.UtcNow;
        UpdateTimestamp();
    }
}
