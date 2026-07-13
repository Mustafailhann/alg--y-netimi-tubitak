using System;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using RealityLens.Application.CQRS.Interfaces;

using System.Linq;

namespace RealityLens.Application.CQRS.Queries.TrainingLibrary;

public record LibraryItemDetailDto(Guid Id, Guid AssessmentId, string Title, string MediaType, string GroundTruthSnapshot, DateTime PublishedAt, Guid Version);

public record GetLibraryItemByIdQuery(Guid Id) : IQuery<LibraryItemDetailDto?>;

public class GetLibraryItemByIdQueryHandler : IQueryHandler<GetLibraryItemByIdQuery, LibraryItemDetailDto?>
{
    private readonly IApplicationDbContext _context;

    public GetLibraryItemByIdQueryHandler(IApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<LibraryItemDetailDto?> HandleAsync(GetLibraryItemByIdQuery query, CancellationToken cancellationToken = default)
    {
        var result = await _context.Assessments
            .AsNoTracking()
            .Where(a => a.Id == query.Id && a.Status == RealityLens.Domain.Enums.AssessmentStatus.Published)
            .Join(_context.Media, 
                  a => a.MediaId, 
                  m => m.Id, 
                  (a, m) => new { Assessment = a, Media = m })
            .Select(x => new LibraryItemDetailDto(
                x.Assessment.Id,
                x.Assessment.Id,
                x.Assessment.Question,
                x.Media.MimeType,
                "{}", // GroundTruth Snapshot is deferred to Assessment Detail endpoint
                x.Assessment.UpdatedAt,
                x.Assessment.Version))
            .FirstOrDefaultAsync(cancellationToken);

        return result;
    }
}
