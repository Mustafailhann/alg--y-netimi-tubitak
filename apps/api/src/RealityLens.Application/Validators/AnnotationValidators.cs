using System.Text.Json;
using FluentValidation;
using RealityLens.Application.DTOs;
using RealityLens.Domain.Enums;

namespace RealityLens.Application.Validators;

public class CreateAnnotationRequestValidator : AbstractValidator<CreateAnnotationRequest>
{
    public CreateAnnotationRequestValidator()
    {

        RuleFor(x => x.Type)
            .IsInEnum()
            .WithMessage("AnnotationType is invalid.");

        RuleFor(x => x.Geometry)
            .Must((request, geometry) => GeometryValidator.IsValid(request.Type, geometry, out _))
            .WithMessage((request, geometry) =>
            {
                GeometryValidator.IsValid(request.Type, geometry, out var error);
                return error ?? "Geometry is invalid.";
            });
    }
}

public class UpdateAnnotationRequestValidator : AbstractValidator<UpdateAnnotationRequest>
{
    public UpdateAnnotationRequestValidator()
    {
        RuleFor(x => x.Type)
            .IsInEnum()
            .WithMessage("AnnotationType is invalid.");

        RuleFor(x => x.Geometry)
            .Must((request, geometry) => GeometryValidator.IsValid(request.Type, geometry, out _))
            .WithMessage((request, geometry) =>
            {
                GeometryValidator.IsValid(request.Type, geometry, out var error);
                return error ?? "Geometry is invalid.";
            });
    }
}

/// <summary>
/// Shared geometry validation logic operating directly on JsonElement.
/// No string parsing occurs here — validation is performed on the already-parsed JSON.
/// </summary>
internal static class GeometryValidator
{
    // ── Point limits ──────────────────────────────────────────────────────────
    private const int PolygonMinPoints = 3;
    private const int PolygonMaxPoints = 512;
    private const int BrushMinPoints   = 2;
    private const int BrushMaxPoints   = 4096;

    public static bool IsValid(AnnotationType type, JsonElement geometry, out string? error)
    {
        if (geometry.ValueKind != JsonValueKind.Object)
        {
            error = "Geometry must be a JSON object.";
            return false;
        }

        return type switch
        {
            AnnotationType.Rectangle => ValidateRectangle(geometry, out error),
            AnnotationType.Polygon   => ValidatePointsShape(geometry, PolygonMinPoints, PolygonMaxPoints, "Polygon", out error),
            AnnotationType.Brush     => ValidatePointsShape(geometry, BrushMinPoints, BrushMaxPoints, "Brush", out error),
            _                        => (error = $"Unsupported AnnotationType '{type}'.") is null,
        };
    }

    // ── Rectangle ─────────────────────────────────────────────────────────────

    private static bool ValidateRectangle(JsonElement obj, out string? error)
    {
        foreach (var field in new[] { "x", "y", "width", "height" })
        {
            if (!obj.TryGetProperty(field, out var prop))
            {
                error = $"Rectangle geometry is missing required field '{field}'.";
                return false;
            }

            if (prop.ValueKind != JsonValueKind.Number)
            {
                error = $"Rectangle field '{field}' must be a number.";
                return false;
            }

            if (!TryGetFiniteDouble(prop, out var value))
            {
                error = $"Rectangle field '{field}' must be a finite number (NaN and Infinity are not allowed).";
                return false;
            }

            if (field is "x" or "y" && value < 0)
            {
                error = $"Rectangle field '{field}' must be ≥ 0.";
                return false;
            }

            if (field is "width" or "height" && value <= 0)
            {
                error = $"Rectangle field '{field}' must be > 0.";
                return false;
            }
        }

        error = null;
        return true;
    }

    // ── Polygon / Brush ───────────────────────────────────────────────────────

    private static bool ValidatePointsShape(
        JsonElement obj,
        int minPoints,
        int maxPoints,
        string shapeName,
        out string? error)
    {
        if (!obj.TryGetProperty("points", out var pointsEl))
        {
            error = $"{shapeName} geometry is missing required field 'points'.";
            return false;
        }

        if (pointsEl.ValueKind != JsonValueKind.Array)
        {
            error = $"{shapeName} field 'points' must be a JSON array.";
            return false;
        }

        var count = pointsEl.GetArrayLength();

        if (count < minPoints)
        {
            error = $"{shapeName} requires at least {minPoints} points (received {count}).";
            return false;
        }

        if (count > maxPoints)
        {
            error = $"{shapeName} exceeds the maximum of {maxPoints} points (received {count}).";
            return false;
        }

        var index = 0;
        foreach (var point in pointsEl.EnumerateArray())
        {
            if (point.ValueKind != JsonValueKind.Array)
            {
                error = $"{shapeName} point at index {index} must be an array [x, y].";
                return false;
            }

            if (point.GetArrayLength() != 2)
            {
                error = $"{shapeName} point at index {index} must have exactly 2 elements [x, y].";
                return false;
            }

            var coordIndex = 0;
            foreach (var coord in point.EnumerateArray())
            {
                var coordName = coordIndex == 0 ? "x" : "y";

                if (coord.ValueKind != JsonValueKind.Number)
                {
                    error = $"{shapeName} point[{index}].{coordName} must be a number.";
                    return false;
                }

                if (!TryGetFiniteDouble(coord, out var coordValue))
                {
                    error = $"{shapeName} point[{index}].{coordName} must be a finite number (NaN and Infinity are not allowed).";
                    return false;
                }

                if (coordValue < 0)
                {
                    error = $"{shapeName} point[{index}].{coordName} must be ≥ 0.";
                    return false;
                }

                coordIndex++;
            }

            index++;
        }

        error = null;
        return true;
    }

    // ── Helpers ───────────────────────────────────────────────────────────────

    /// <summary>
    /// Attempts to extract a finite double from a JSON Number element.
    /// Returns false for NaN and Infinity (which cannot be represented in JSON
    /// but may appear in edge cases depending on serializer behaviour).
    /// </summary>
    private static bool TryGetFiniteDouble(JsonElement element, out double value)
    {
        if (!element.TryGetDouble(out value))
        {
            return false;
        }

        return double.IsFinite(value);
    }
}
