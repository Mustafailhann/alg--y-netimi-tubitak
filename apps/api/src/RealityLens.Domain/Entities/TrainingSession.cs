using RealityLens.Domain.Common;
using RealityLens.Domain.Enums;
using RealityLens.Domain.ValueObjects;
using System;
using System.Collections.Generic;

namespace RealityLens.Domain.Entities;

public class TrainingSession : BaseEntity, IAggregateRoot
{
    public Guid TrainingPackId { get; private set; }
    public TrainingPack TrainingPack { get; private set; } = null!;
    
    public JoinCode JoinCode { get; private set; } = null!;
    
    public SessionConfiguration Configuration { get; private set; } = null!;
    
    public TrainingSessionStatus Status { get; private set; }
    
    // Audit & tracking fields
    public Guid CreatedBy { get; private set; }
    
    public Guid? StartedBy { get; private set; }
    public DateTime? StartedAt { get; private set; }
    
    public Guid? EndedBy { get; private set; }
    public DateTime? EndedAt { get; private set; }
    
    public int ParticipantCount { get; private set; }
    public int CurrentQuestionIndex { get; private set; }

    private readonly List<Participant> _participants = new();
    public IReadOnlyCollection<Participant> Participants => _participants.AsReadOnly();

    private TrainingSession() { } // EF Core

    public TrainingSession(Guid trainingPackId, Guid createdBy, JoinCode joinCode, SessionConfiguration configuration)
    {
        TrainingPackId = trainingPackId;
        CreatedBy = createdBy;
        JoinCode = joinCode;
        Configuration = configuration;
        Status = TrainingSessionStatus.Scheduled;
        ParticipantCount = 0;
        CurrentQuestionIndex = 0;
    }

    public void Start(Guid startedBy)
    {
        if (Status != TrainingSessionStatus.Scheduled && Status != TrainingSessionStatus.Paused)
            throw new InvalidOperationException("Only Scheduled or Paused sessions can be started.");

        Status = TrainingSessionStatus.Active;
        StartedBy ??= startedBy;
        StartedAt ??= DateTime.UtcNow;
        UpdateTimestamp();
    }

    public void Pause()
    {
        if (Status != TrainingSessionStatus.Active)
            throw new InvalidOperationException("Only Active sessions can be paused.");

        Status = TrainingSessionStatus.Paused;
        UpdateTimestamp();
    }

    public void End(Guid endedBy)
    {
        if (Status == TrainingSessionStatus.Finished || Status == TrainingSessionStatus.Cancelled)
            return;

        Status = TrainingSessionStatus.Finished;
        EndedBy = endedBy;
        EndedAt = DateTime.UtcNow;
        UpdateTimestamp();
    }
    
    public void FinishSession(Guid requestedBy)
    {
        End(requestedBy);
    }
    
    public void NextQuestion(Guid requestedBy)
    {
        if (Status != TrainingSessionStatus.Active)
            throw new InvalidOperationException("Can only advance questions in an Active session.");
            
        CurrentQuestionIndex++;
        UpdateTimestamp();
    }

    public void Cancel(Guid cancelledBy)
    {
        if (Status == TrainingSessionStatus.Finished || Status == TrainingSessionStatus.Cancelled)
            return;

        Status = TrainingSessionStatus.Cancelled;
        EndedBy = cancelledBy;
        EndedAt = DateTime.UtcNow;
        UpdateTimestamp();
    }

    public void AddParticipant(Participant participant)
    {
        if (Status != TrainingSessionStatus.Scheduled && Status != TrainingSessionStatus.Active)
            throw new InvalidOperationException("Participants can only join Scheduled or Active sessions.");

        _participants.Add(participant);
        ParticipantCount = _participants.Count;
        UpdateTimestamp();
    }

    public void IncrementParticipantCount()
    {
        ParticipantCount++;
        UpdateTimestamp();
    }
}
