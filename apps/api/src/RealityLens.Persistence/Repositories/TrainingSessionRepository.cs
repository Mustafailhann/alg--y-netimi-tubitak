using Microsoft.EntityFrameworkCore;
using RealityLens.Domain.Entities;
using RealityLens.Domain.Repositories;
using RealityLens.Domain.ValueObjects;
using System;
using System.Threading;
using System.Threading.Tasks;

namespace RealityLens.Persistence.Repositories;

public class TrainingSessionRepository : ITrainingSessionRepository
{
    private readonly RealityLensDbContext _context;

    public TrainingSessionRepository(RealityLensDbContext context)
    {
        _context = context;
    }

    public async Task<TrainingSession?> GetByIdAsync(Guid id, CancellationToken cancellationToken = default)
    {
        return await _context.TrainingSessions
            .Include(x => x.Participants)
            .FirstOrDefaultAsync(x => x.Id == id, cancellationToken);
    }

    public async Task<TrainingSession?> GetByJoinCodeAsync(JoinCode joinCode, CancellationToken cancellationToken = default)
    {
        return await _context.TrainingSessions
            .Include(x => x.Participants)
            .FirstOrDefaultAsync(x => x.JoinCode.Value == joinCode.Value, cancellationToken);
    }

    public async Task<bool> IsJoinCodeUniqueAsync(JoinCode joinCode, CancellationToken cancellationToken = default)
    {
        return !await _context.TrainingSessions
            .AnyAsync(x => x.JoinCode.Value == joinCode.Value, cancellationToken);
    }

    public async Task AddAsync(TrainingSession session, CancellationToken cancellationToken = default)
    {
        await _context.TrainingSessions.AddAsync(session, cancellationToken);
        await _context.SaveChangesAsync(cancellationToken);
    }

    public async Task UpdateAsync(TrainingSession session, CancellationToken cancellationToken = default)
    {
        // Workaround for EF Core assuming new Participants with initialized Guids are Modified
        foreach (var participant in session.Participants)
        {
            var entry = _context.Entry(participant);
            if (entry.State == EntityState.Modified)
            {
                // If we know it's a new participant (e.g., just joined), force it to Added
                // We can't query DB for each, but we can assume if it's failing to update, it should be Added
                // Actually, just checking if it exists locally is enough.
                // A safer way is to check if it's recently created.
                if (participant.CreatedAt == participant.UpdatedAt)
                {
                    entry.State = EntityState.Added;
                }
            }
        }
        
        await _context.SaveChangesAsync(cancellationToken);
    }
}
