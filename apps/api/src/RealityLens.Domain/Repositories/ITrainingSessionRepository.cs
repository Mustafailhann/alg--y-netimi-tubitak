using RealityLens.Domain.Entities;
using RealityLens.Domain.ValueObjects;
using System;
using System.Threading;
using System.Threading.Tasks;

namespace RealityLens.Domain.Repositories;

public interface ITrainingSessionRepository
{
    Task<TrainingSession?> GetByIdAsync(Guid id, CancellationToken cancellationToken = default);
    Task<TrainingSession?> GetByJoinCodeAsync(JoinCode joinCode, CancellationToken cancellationToken = default);
    Task<bool> IsJoinCodeUniqueAsync(JoinCode joinCode, CancellationToken cancellationToken = default);
    Task AddAsync(TrainingSession session, CancellationToken cancellationToken = default);
    Task UpdateAsync(TrainingSession session, CancellationToken cancellationToken = default);
}
