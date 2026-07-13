using RealityLens.Domain.Common;
using RealityLens.Domain.Enums;
using System;

namespace RealityLens.Domain.Entities;

public class Participant : BaseEntity
{
    public Guid TrainingSessionId { get; private set; }
    public TrainingSession TrainingSession { get; private set; } = null!;
    
    public string StudentIdentifier { get; private set; }

    public DateTime JoinedAt { get; private set; }
    
    // Live session fields
    public int ProgressPercentage { get; private set; }
    public int Score { get; private set; }
    public DateTime? FinishedAt { get; private set; }
    public Guid? CurrentAttemptId { get; private set; }
    public ConnectionStatus ConnectionStatus { get; private set; }
    public DateTime LastSeen { get; private set; }
    public DateTime? LastHeartbeatAt { get; private set; }

    private Participant() { StudentIdentifier = string.Empty; } // EF Core

    public Participant(Guid trainingSessionId, string studentIdentifier)
    {
        TrainingSessionId = trainingSessionId;
        StudentIdentifier = studentIdentifier;
        JoinedAt = DateTime.UtcNow;
        ProgressPercentage = 0;
        Score = 0;
        ConnectionStatus = ConnectionStatus.Online;
        LastSeen = DateTime.UtcNow;
        LastHeartbeatAt = DateTime.UtcNow;
    }

    public void UpdateConnectionStatus(ConnectionStatus status)
    {
        ConnectionStatus = status;
        LastSeen = DateTime.UtcNow;
    }
    
    public void RecordHeartbeat()
    {
        LastHeartbeatAt = DateTime.UtcNow;
        if (ConnectionStatus != ConnectionStatus.Online)
        {
            ConnectionStatus = ConnectionStatus.Online;
        }
        LastSeen = DateTime.UtcNow;
    }

    public void Leave()
    {
        ConnectionStatus = ConnectionStatus.Offline;
        LastSeen = DateTime.UtcNow;
    }

    public void UpdateProgress(int newPercentage, int? newScore = null, Guid? attemptId = null)
    {
        ProgressPercentage = newPercentage;
        if (newScore.HasValue) Score = newScore.Value;
        if (attemptId.HasValue) CurrentAttemptId = attemptId;
        
        if (ProgressPercentage >= 100 && !FinishedAt.HasValue)
        {
            FinishedAt = DateTime.UtcNow;
        }
        
        LastSeen = DateTime.UtcNow;
    }
}
