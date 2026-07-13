using Xunit;
using RealityLens.Application.Services;
using RealityLens.Domain.Enums;

namespace RealityLens.Application.Tests.Services;

public class ScoringServiceTests
{
    private readonly ScoringService _service;

    public ScoringServiceTests()
    {
        _service = new ScoringService();
    }

    [Fact]
    public void ScoreAnswer_RealCorrect_Returns100Total()
    {
        var groundTruthSnapshot = @"{""Judgment"": ""Real""}";
        
        var result = _service.ScoreAnswer(
            Judgment.Real,
            groundTruthSnapshot,
            Judgment.Real,
            null);

        Assert.Equal(100m, result.ClassificationScore);
        Assert.Equal(0m, result.LocalizationScore);
        Assert.Equal(100m, result.TotalScore);
        Assert.True(result.IsCorrect);
    }

    [Fact]
    public void ScoreAnswer_RealIncorrect_Returns0Total()
    {
        var groundTruthSnapshot = @"{""Judgment"": ""Real""}";
        
        var result = _service.ScoreAnswer(
            Judgment.Real,
            groundTruthSnapshot,
            Judgment.Manipulated,
            null);

        Assert.Equal(0m, result.ClassificationScore);
        Assert.Equal(0m, result.LocalizationScore);
        Assert.Equal(0m, result.TotalScore);
        Assert.False(result.IsCorrect);
    }

    [Fact]
    public void ScoreAnswer_ManipulatedCorrect_PerfectLocalization_Returns100Total()
    {
        var groundTruthSnapshot = @"{
            ""Judgment"": ""Manipulated"",
            ""Annotations"": [
                {
                    ""Type"": ""Rectangle"",
                    ""Geometry"": {""x"": 0, ""y"": 0, ""width"": 100, ""height"": 100}
                }
            ]
        }";
        var submittedGeometry = @"[
            {
                ""Type"": ""Rectangle"",
                ""Geometry"": {""x"": 0, ""y"": 0, ""width"": 100, ""height"": 100}
            }
        ]";

        var result = _service.ScoreAnswer(
            Judgment.Manipulated,
            groundTruthSnapshot,
            Judgment.Manipulated,
            submittedGeometry);

        Assert.Equal(100m, result.ClassificationScore);
        Assert.Equal(100m, result.LocalizationScore);
        Assert.Equal(100m, result.TotalScore);
        Assert.True(result.IsCorrect);
    }

    [Fact]
    public void ScoreAnswer_ManipulatedCorrect_BadLocalization_Returns50Total()
    {
        var groundTruthSnapshot = @"{
            ""Judgment"": ""Manipulated"",
            ""Annotations"": [
                {
                    ""Type"": ""Rectangle"",
                    ""Geometry"": {""x"": 0, ""y"": 0, ""width"": 10, ""height"": 10}
                }
            ]
        }";
        var submittedGeometry = @"[
            {
                ""Type"": ""Rectangle"",
                ""Geometry"": {""x"": 50, ""y"": 50, ""width"": 10, ""height"": 10}
            }
        ]";

        var result = _service.ScoreAnswer(
            Judgment.Manipulated,
            groundTruthSnapshot,
            Judgment.Manipulated,
            submittedGeometry);

        Assert.Equal(100m, result.ClassificationScore);
        Assert.Equal(0m, result.LocalizationScore);
        Assert.Equal(50m, result.TotalScore);
        Assert.True(result.IsCorrect); // Total score is 50, which is >= 50, so IsCorrect is true
    }

    [Fact]
    public void ScoreAnswer_ManipulatedIncorrect_Returns0Total()
    {
        var groundTruthSnapshot = @"{
            ""Judgment"": ""Manipulated"",
            ""Annotations"": [
                {
                    ""Type"": ""Rectangle"",
                    ""Geometry"": {""x"": 0, ""y"": 0, ""width"": 100, ""height"": 100}
                }
            ]
        }";
        
        var result = _service.ScoreAnswer(
            Judgment.Manipulated,
            groundTruthSnapshot,
            Judgment.Real,
            null);

        Assert.Equal(0m, result.ClassificationScore);
        Assert.Equal(0m, result.LocalizationScore);
        Assert.Equal(0m, result.TotalScore);
        Assert.False(result.IsCorrect);
    }
}
