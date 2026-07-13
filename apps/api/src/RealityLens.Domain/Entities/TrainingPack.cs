using RealityLens.Domain.Common;
using RealityLens.Domain.Enums;
using System;
using System.Collections.Generic;

namespace RealityLens.Domain.Entities;

public class TrainingPack : BaseEntity, IAggregateRoot
{
    public Guid TeacherId { get; private set; }
    public string Title { get; private set; }
    public TrainingPackStatus Status { get; private set; }
    public int? EstimatedDuration { get; private set; }
    
    // Audit fields
    public Guid CreatedBy { get; private set; }
    public Guid? PublishedBy { get; private set; }
    public DateTime? PublishedAt { get; private set; }
    public Guid? ArchivedBy { get; private set; }
    public DateTime? ArchivedAt { get; private set; }

    private readonly List<TrainingItem> _trainingItems = new();
    public IReadOnlyCollection<TrainingItem> TrainingItems => _trainingItems.AsReadOnly();

    private readonly List<TrainingSession> _trainingSessions = new();
    public IReadOnlyCollection<TrainingSession> TrainingSessions => _trainingSessions.AsReadOnly();

    private TrainingPack() { Title = string.Empty; } // EF Core

    public TrainingPack(Guid teacherId, string title, int? estimatedDuration = null)
    {
        TeacherId = teacherId;
        Title = title;
        Status = TrainingPackStatus.Draft;
        EstimatedDuration = estimatedDuration;
        CreatedBy = teacherId;
    }

    private void EnsureDraft()
    {
        if (Status != TrainingPackStatus.Draft)
            throw new InvalidOperationException("Cannot perform this action on a non-draft Training Pack.");
    }

    public void Update(string title, int? estimatedDuration)
    {
        EnsureDraft();

        if (string.IsNullOrWhiteSpace(title))
            throw new ArgumentException("Title cannot be empty.", nameof(title));

        Title = title.Trim();
        EstimatedDuration = estimatedDuration;

        UpdateTimestamp();
    }

    public void AddTrainingItem(TrainingItem item)
    {
        EnsureDraft();
        
        _trainingItems.Add(item);
        UpdateTimestamp();
    }

    public void RemoveTrainingItem(Guid trainingItemId)
    {
        EnsureDraft();
        
        var item = _trainingItems.Find(x => x.Id == trainingItemId);
        if (item == null)
            throw new InvalidOperationException($"TrainingItem {trainingItemId} not found in this pack.");

        item.Delete(); // Soft delete the item
        // _trainingItems.Remove(item); // Depending on EF Core setup, removing it might orphan it, or soft deleting it is better.
        UpdateTimestamp();
    }

    public void ReorderTrainingItems(List<Guid> orderedIds)
    {
        EnsureDraft();

        var activeItems = _trainingItems.FindAll(x => !x.IsDeleted);
        if (orderedIds.Count != activeItems.Count)
            throw new ArgumentException("Ordered IDs count does not match active TrainingItems count.");

        for (int i = 0; i < orderedIds.Count; i++)
        {
            var item = activeItems.Find(x => x.Id == orderedIds[i]);
            if (item == null)
                throw new ArgumentException($"TrainingItem {orderedIds[i]} not found in this pack.");
            
            item.UpdateOrderIndex(i);
        }

        UpdateTimestamp();
    }

    public void Publish(Guid publishedBy)
    {
        if (Status != TrainingPackStatus.Draft)
            throw new InvalidOperationException("Only draft Training Packs can be published.");
        if (_trainingItems.Count == 0)
            throw new InvalidOperationException("Cannot publish an empty Training Pack.");

        Status = TrainingPackStatus.Published;
        PublishedBy = publishedBy;
        PublishedAt = DateTime.UtcNow;
        UpdateTimestamp();
    }

    public void Archive(Guid archivedBy)
    {
        if (Status == TrainingPackStatus.Archived) return;

        Status = TrainingPackStatus.Archived;
        ArchivedBy = archivedBy;
        ArchivedAt = DateTime.UtcNow;
        UpdateTimestamp();
    }
}
