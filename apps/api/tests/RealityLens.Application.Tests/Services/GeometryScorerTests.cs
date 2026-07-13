using System.Text.Json;
using RealityLens.Domain.Enums;
using Xunit;
using RealityLens.Application.Services;

namespace RealityLens.Application.Tests.Services;

public class GeometryScorerTests
{
    [Fact]
    public void CalculateIoU_TwoIdenticalRectangles_Returns1()
    {
        var truthJson = JsonSerializer.Deserialize<JsonElement>(@"[ { ""Type"": ""Rectangle"", ""Geometry"": { ""x"": 0, ""y"": 0, ""width"": 100, ""height"": 100 } } ]");
        var answerJson = JsonSerializer.Deserialize<JsonElement>(@"[ { ""Type"": ""Rectangle"", ""Geometry"": { ""x"": 0, ""y"": 0, ""width"": 100, ""height"": 100 } } ]");

        var iou = GeometryScorer.CalculateIoU(truthJson, answerJson);

        Assert.Equal(1m, iou);
    }

    [Fact]
    public void CalculateIoU_NonOverlappingRectangles_Returns0()
    {
        var truthJson = JsonSerializer.Deserialize<JsonElement>(@"[ { ""Type"": ""Rectangle"", ""Geometry"": { ""x"": 0, ""y"": 0, ""width"": 10, ""height"": 10 } } ]");
        var answerJson = JsonSerializer.Deserialize<JsonElement>(@"[ { ""Type"": ""Rectangle"", ""Geometry"": { ""x"": 20, ""y"": 20, ""width"": 10, ""height"": 10 } } ]");

        var iou = GeometryScorer.CalculateIoU(truthJson, answerJson);

        Assert.Equal(0m, iou);
    }

    [Fact]
    public void CalculateIoU_HalfOverlappingRectangles_ReturnsCorrectIoU()
    {
        var truthJson = JsonSerializer.Deserialize<JsonElement>(@"[ { ""Type"": ""Rectangle"", ""Geometry"": { ""x"": 0, ""y"": 0, ""width"": 10, ""height"": 10 } } ]");
        var answerJson = JsonSerializer.Deserialize<JsonElement>(@"[ { ""Type"": ""Rectangle"", ""Geometry"": { ""x"": 5, ""y"": 0, ""width"": 10, ""height"": 10 } } ]");
        
        var iou = GeometryScorer.CalculateIoU(truthJson, answerJson);

        Assert.True(iou > 0.33m && iou < 0.34m);
    }

    [Fact]
    public void CalculateIoU_PolygonWithBoundingBox_ReturnsIoU()
    {
        var truthJson = JsonSerializer.Deserialize<JsonElement>(@"[ { ""Type"": ""Rectangle"", ""Geometry"": { ""x"": 0, ""y"": 0, ""width"": 10, ""height"": 10 } } ]");
        var answerJson = JsonSerializer.Deserialize<JsonElement>(@"[ { ""Type"": ""Polygon"", ""Geometry"": { ""points"": [[0, 0], [10, 0], [10, 10], [0, 10]] } } ]");

        var iou = GeometryScorer.CalculateIoU(truthJson, answerJson);

        Assert.Equal(1m, iou);
    }
}
