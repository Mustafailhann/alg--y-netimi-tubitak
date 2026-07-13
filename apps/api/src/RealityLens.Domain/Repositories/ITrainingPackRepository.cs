using RealityLens.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace RealityLens.Domain.Repositories;

public interface ITrainingPackRepository
{
    Task<TrainingPack?> GetByIdAsync(Guid id, CancellationToken cancellationToken = default);
    Task<IEnumerable<TrainingPack>> GetByTeacherIdAsync(Guid teacherId, CancellationToken cancellationToken = default);
    Task AddAsync(TrainingPack pack, CancellationToken cancellationToken = default);
    Task UpdateAsync(TrainingPack pack, CancellationToken cancellationToken = default);
    Task AddTrainingItemAsync(TrainingItem item, CancellationToken cancellationToken = default);
}
