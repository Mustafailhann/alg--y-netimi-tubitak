using System;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using RealityLens.Application.CQRS.Interfaces;
using RealityLens.Domain.Enums;

using System.Linq;

namespace RealityLens.Application.CQRS.Queries.TrainingPacks;

public record TrainingPackDetailDto(Guid Id, Guid TeacherId, string Title, TrainingPackStatus Status, int? EstimatedDuration, Guid Version, DateTime CreatedAt);

public record GetTrainingPackByIdQuery(Guid PackId, Guid TeacherId) : IQuery<TrainingPackDetailDto?>;

public class GetTrainingPackByIdQueryHandler : IQueryHandler<GetTrainingPackByIdQuery, TrainingPackDetailDto?>
{
    private readonly IApplicationDbContext _context;

    public GetTrainingPackByIdQueryHandler(IApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<TrainingPackDetailDto?> HandleAsync(GetTrainingPackByIdQuery query, CancellationToken cancellationToken = default)
    {
        return await _context.TrainingPacks
            .AsNoTracking()
            .Where(x => x.Id == query.PackId && x.TeacherId == query.TeacherId)
            .Select(x => new TrainingPackDetailDto(x.Id, x.TeacherId, x.Title, x.Status, x.EstimatedDuration, x.Version, x.CreatedAt))
            .FirstOrDefaultAsync(cancellationToken);
    }
}
