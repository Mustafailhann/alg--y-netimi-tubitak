using System;
using System.Text.Json;
using RealityLens.Domain.Enums;
using System.Linq;

namespace RealityLens.Application.Services;

public static class GeometryScorer
{
    public static decimal CalculateIoU(JsonElement truthAnnotations, JsonElement answerAnnotations)
    {
        var truthGeoms = ParseGeometries(truthAnnotations);
        var answerGeoms = ParseGeometries(answerAnnotations);

        if (!truthGeoms.Any() || !answerGeoms.Any())
            return 0m;

        try
        {
            var factory = NetTopologySuite.NtsGeometryServices.Instance.CreateGeometryFactory();
            var truthUnion = factory.BuildGeometry(truthGeoms).Union();
            var answerUnion = factory.BuildGeometry(answerGeoms).Union();

            if (truthUnion.IsEmpty || answerUnion.IsEmpty)
                return 0m;

            var intersection = truthUnion.Intersection(answerUnion);
            var union = truthUnion.Union(answerUnion);

            if (union.Area <= 0) return 0m;

            return (decimal)(intersection.Area / union.Area);
        }
        catch
        {
            return 0m;
        }
    }

    private static System.Collections.Generic.List<NetTopologySuite.Geometries.Geometry> ParseGeometries(JsonElement annotationsArray)
    {
        var result = new System.Collections.Generic.List<NetTopologySuite.Geometries.Geometry>();
        if (annotationsArray.ValueKind != JsonValueKind.Array)
            return result;

        var factory = NetTopologySuite.NtsGeometryServices.Instance.CreateGeometryFactory();

        foreach (var ann in annotationsArray.EnumerateArray())
        {
            try
            {
                var typeStr = ann.GetProperty("Type").GetString();
                if (!Enum.TryParse<AnnotationType>(typeStr, out var type))
                    continue;

                var geomEl = ann.GetProperty("Geometry");

                if (type == AnnotationType.Rectangle)
                {
                    var x = geomEl.GetProperty("x").GetDouble();
                    var y = geomEl.GetProperty("y").GetDouble();
                    var w = geomEl.GetProperty("width").GetDouble();
                    var h = geomEl.GetProperty("height").GetDouble();
                    
                    var coords = new NetTopologySuite.Geometries.Coordinate[]
                    {
                        new(x, y),
                        new(x + w, y),
                        new(x + w, y + h),
                        new(x, y + h),
                        new(x, y)
                    };
                    result.Add(factory.CreatePolygon(coords));
                }
                else if (type == AnnotationType.Polygon || type == AnnotationType.Brush)
                {
                    var pointsEl = geomEl.GetProperty("points");
                    var coords = new System.Collections.Generic.List<NetTopologySuite.Geometries.Coordinate>();
                    
                    foreach (var p in pointsEl.EnumerateArray())
                    {
                        var arr = p.EnumerateArray().ToArray();
                        coords.Add(new NetTopologySuite.Geometries.Coordinate(arr[0].GetDouble(), arr[1].GetDouble()));
                    }

                    if (coords.Count >= 3)
                    {
                        // Ensure polygon is closed
                        if (!coords.First().Equals2D(coords.Last()))
                        {
                            coords.Add(new NetTopologySuite.Geometries.Coordinate(coords.First().X, coords.First().Y));
                        }
                        
                        var polygon = factory.CreatePolygon(coords.ToArray());
                        if (polygon.IsValid)
                        {
                            result.Add(polygon);
                        }
                        else
                        {
                            // Try to make it valid
                            var valid = polygon.Buffer(0);
                            result.Add(valid);
                        }
                    }
                }
            }
            catch
            {
                // Ignore malformed annotation
            }
        }

        return result;
    }
}
