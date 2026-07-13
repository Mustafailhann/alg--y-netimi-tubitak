using Microsoft.EntityFrameworkCore;
using RealityLens.Domain.Entities;
using RealityLens.Domain.Repositories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace RealityLens.Persistence.Repositories;

public class TrainingPackRepository : ITrainingPackRepository
{
    private readonly RealityLensDbContext _context;

    public TrainingPackRepository(RealityLensDbContext context)
    {
        _context = context;
    }

    public async Task<TrainingPack?> GetByIdAsync(Guid id, CancellationToken cancellationToken = default)
    {
        return await _context.TrainingPacks
            .Include(x => x.TrainingItems)
            .FirstOrDefaultAsync(x => x.Id == id, cancellationToken);
    }

    public async Task<IEnumerable<TrainingPack>> GetByTeacherIdAsync(Guid teacherId, CancellationToken cancellationToken = default)
    {
        return await _context.TrainingPacks
            .Where(x => x.TeacherId == teacherId)
            .ToListAsync(cancellationToken);
    }

    public async Task AddAsync(TrainingPack pack, CancellationToken cancellationToken = default)
    {
        await _context.TrainingPacks.AddAsync(pack, cancellationToken);
        await _context.SaveChangesAsync(cancellationToken);
    }

    public async Task UpdateAsync(TrainingPack pack, CancellationToken cancellationToken = default)
    {
        try
        {
            await _context.SaveChangesAsync(cancellationToken);
        }
        catch (Microsoft.EntityFrameworkCore.DbUpdateConcurrencyException ex)
        {
            var entries = string.Join(", ", ex.Entries.Select(e => e.Entity.GetType().Name));
            throw new Exception($"Concurrency error on entities: {entries}", ex);
        }
    }

    public async Task AddTrainingItemAsync(TrainingItem item, CancellationToken cancellationToken = default)
    {
        await _context.TrainingItems.AddAsync(item, cancellationToken);
    }
}
