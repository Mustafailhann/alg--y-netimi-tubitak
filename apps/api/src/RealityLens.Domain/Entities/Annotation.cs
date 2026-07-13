using RealityLens.Domain.Common;
using RealityLens.Domain.Enums;
using System;

namespace RealityLens.Domain.Entities;

public class Annotation : BaseEntity
{
    public Guid CreatedBy { get; private set; }

    public AnnotationType Type { get; private set; }
    public string GeometryData { get; private set; }

    public Guid? GroundTruthId { get; private set; }
    public GroundTruth? GroundTruth { get; private set; }

    public Guid? ParticipantAnswerId { get; private set; }
    public ParticipantAnswer? ParticipantAnswer { get; private set; }

    public float? StartSeconds { get; private set; }
    public float? EndSeconds { get; private set; }

    private Annotation() { GeometryData = null!; } // EF Core

    public Annotation(AnnotationType type, string geometryData, Guid createdBy, float? startSeconds = null, float? endSeconds = null, Guid? groundTruthId = null, Guid? participantAnswerId = null)
    {
        if (startSeconds.HasValue && endSeconds.HasValue && startSeconds >= endSeconds)
        {
            throw new ArgumentException("StartSeconds must be less than EndSeconds.");
        }

        CreatedBy = createdBy;
        Type = type;
        GeometryData = geometryData ?? throw new ArgumentNullException(nameof(geometryData));
        StartSeconds = startSeconds;
        EndSeconds = endSeconds;
        GroundTruthId = groundTruthId;
        ParticipantAnswerId = participantAnswerId;
    }

    public void LinkToParticipantAnswer(Guid answerId)
    {
        ParticipantAnswerId = answerId;
        UpdateTimestamp();
    }

    public void Update(AnnotationType type, string geometryData)
    {
        if (string.IsNullOrWhiteSpace(geometryData))
        {
            throw new ArgumentException("GeometryData cannot be null or empty.", nameof(geometryData));
        }

        Type = type;
        GeometryData = geometryData;
        UpdateTimestamp();
    }
}
