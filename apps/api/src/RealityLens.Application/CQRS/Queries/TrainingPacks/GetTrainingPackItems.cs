using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using RealityLens.Application.CQRS.Interfaces;

using System.Linq;

namespace RealityLens.Application.CQRS.Queries.TrainingPacks;

public record TrainingItemDto(Guid Id, Guid LibraryItemId, int OrderIndex, string LibraryItemTitle, string LibraryItemMediaType);

public record GetTrainingPackItemsQuery(Guid PackId, Guid TeacherId) : IQuery<IEnumerable<TrainingItemDto>>;

public class GetTrainingPackItemsQueryHandler : IQueryHandler<GetTrainingPackItemsQuery, IEnumerable<TrainingItemDto>>
{
    private readonly IApplicationDbContext _context;

    public GetTrainingPackItemsQueryHandler(IApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<IEnumerable<TrainingItemDto>> HandleAsync(GetTrainingPackItemsQuery query, CancellationToken cancellationToken = default)
    {
        // First check authorization
        var packExistsAndAuthorized = await _context.TrainingPacks
            .AnyAsync(x => x.Id == query.PackId && x.TeacherId == query.TeacherId, cancellationToken);
            
        if (!packExistsAndAuthorized)
            return Enumerable.Empty<TrainingItemDto>();

        var items = await (from ti in _context.TrainingItems
                           join a in _context.Assessments on ti.AssessmentId equals a.Id
                           join m in _context.Media on a.MediaId equals m.Id
                           where ti.TrainingPackId == query.PackId
                           orderby ti.OrderIndex
                           select new TrainingItemDto(
                               ti.Id, 
                               ti.AssessmentId, 
                               ti.OrderIndex, 
                               a.Question, // Used as Title for simplicity
                               m.MimeType))
                          .ToListAsync(cancellationToken);
                          
        return items;
    }
}
