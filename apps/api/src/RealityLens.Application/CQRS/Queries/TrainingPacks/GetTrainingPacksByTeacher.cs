using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using RealityLens.Application.CQRS.Interfaces;
using RealityLens.Domain.Enums;
 // Normally we'd use a Read-Only DbContext or Dapper, but I'll use EF Core directly for queries in manual CQRS
using System.Linq;

namespace RealityLens.Application.CQRS.Queries.TrainingPacks;

public record TrainingPackDto(Guid Id, string Title, TrainingPackStatus Status, int? EstimatedDuration, int ItemCount, Guid Version);

public record GetTrainingPacksByTeacherQuery(Guid TeacherId) : IQuery<IEnumerable<TrainingPackDto>>;

public class GetTrainingPacksByTeacherQueryHandler : IQueryHandler<GetTrainingPacksByTeacherQuery, IEnumerable<TrainingPackDto>>
{
    private readonly IApplicationDbContext _context;

    public GetTrainingPacksByTeacherQueryHandler(IApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<IEnumerable<TrainingPackDto>> HandleAsync(GetTrainingPacksByTeacherQuery query, CancellationToken cancellationToken = default)
    {
        return await _context.TrainingPacks
            .AsNoTracking()
            .Where(x => x.TeacherId == query.TeacherId)
            .Select(x => new TrainingPackDto(x.Id, x.Title, x.Status, x.EstimatedDuration, x.TrainingItems.Count, x.Version))
            .ToListAsync(cancellationToken);
    }
}
