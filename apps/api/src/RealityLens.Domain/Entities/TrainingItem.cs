using RealityLens.Domain.Common;
using System;

namespace RealityLens.Domain.Entities;

public class TrainingItem : BaseEntity
{
    public Guid TrainingPackId { get; private set; }
    public TrainingPack TrainingPack { get; private set; } = null!;

    public Guid AssessmentId { get; private set; }
    public Assessment Assessment { get; private set; } = null!;

    public int OrderIndex { get; private set; }

    private TrainingItem() { } // EF Core

    public TrainingItem(Guid trainingPackId, Guid assessmentId, int orderIndex)
    {
        TrainingPackId = trainingPackId;
        AssessmentId = assessmentId;
        OrderIndex = orderIndex;
    }

    public void UpdateOrderIndex(int newIndex)
    {
        OrderIndex = newIndex;
        UpdateTimestamp();
    }
}
