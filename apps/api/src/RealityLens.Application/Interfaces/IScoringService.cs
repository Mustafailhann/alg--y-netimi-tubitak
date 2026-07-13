using System;
using System.Text.Json;
using RealityLens.Domain.Enums;

namespace RealityLens.Application.Interfaces;

public class ScoringResult
{
    public decimal ClassificationScore { get; set; }
    public decimal LocalizationScore { get; set; }
    public decimal TotalScore { get; set; }
    public bool IsCorrect { get; set; }
}

public interface IScoringService
{
    ScoringResult ScoreAnswer(
        Judgment expectedJudgment,
        string groundTruthSnapshot,
        Judgment submittedJudgment,
        string? submittedGeometryData);
}
