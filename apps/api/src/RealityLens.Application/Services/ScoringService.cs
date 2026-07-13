using System;
using System.Text.Json;
using RealityLens.Application.Interfaces;
using RealityLens.Domain.Enums;

namespace RealityLens.Application.Services;

public class ScoringService : IScoringService
{
    public ScoringResult ScoreAnswer(
        Judgment expectedJudgment,
        string groundTruthSnapshot,
        Judgment submittedJudgment,
        string? submittedGeometryData)
    {
        var result = new ScoringResult();

        // 1. Classification
        result.ClassificationScore = (expectedJudgment == submittedJudgment) ? 100m : 0m;

        // 2. Localization
        if (expectedJudgment == Judgment.Manipulated && submittedJudgment == Judgment.Manipulated)
        {
            if (!string.IsNullOrEmpty(submittedGeometryData))
            {
                try
                {
                    var snapshotJson = JsonSerializer.Deserialize<JsonElement>(groundTruthSnapshot);
                    if (snapshotJson.TryGetProperty("Annotations", out var truthAnnotations))
                    {
                        var answerAnnotations = JsonSerializer.Deserialize<JsonElement>(submittedGeometryData);
                        var iou = GeometryScorer.CalculateIoU(truthAnnotations, answerAnnotations);
                        result.LocalizationScore = iou * 100m;
                    }
                }
                catch
                {
                    // If parsing fails, localization is 0
                    result.LocalizationScore = 0m;
                }
            }
            else
            {
                result.LocalizationScore = 0m;
            }
        }
        else
        {
            // For Real, localization is NA but we can set 0
            result.LocalizationScore = 0m;
        }

        // 3. Total Score
        if (expectedJudgment == Judgment.Real)
        {
            result.TotalScore = result.ClassificationScore;
        }
        else
        {
            result.TotalScore = (result.ClassificationScore + result.LocalizationScore) / 2m;
        }

        // 4. Correctness Decision
        result.IsCorrect = result.TotalScore >= 50m;

        return result;
    }
}
