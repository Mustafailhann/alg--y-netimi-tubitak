using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using RealityLens.Application.CQRS.Interfaces;

using System.Linq;

namespace RealityLens.Application.CQRS.Queries.TrainingLibrary;

public record LibraryItemSummaryDto(Guid Id, Guid AssessmentId, string Title, string MediaType, DateTime PublishedAt, Guid Version);

public record SearchLibraryItemsQuery(string? Keyword, string? Difficulty, string? ManipulationType, string? MediaType, List<string>? Tags, DateTime? PublishedAfter, DateTime? PublishedBefore) : IQuery<IEnumerable<LibraryItemSummaryDto>>;

public class SearchLibraryItemsQueryHandler : IQueryHandler<SearchLibraryItemsQuery, IEnumerable<LibraryItemSummaryDto>>
{
    private readonly IApplicationDbContext _context;

    public SearchLibraryItemsQueryHandler(IApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<IEnumerable<LibraryItemSummaryDto>> HandleAsync(SearchLibraryItemsQuery query, CancellationToken cancellationToken = default)
    {
        var queryable = _context.Assessments
            .AsNoTracking()
            .Where(a => a.Status == RealityLens.Domain.Enums.AssessmentStatus.Published)
            .Join(_context.Media, 
                  a => a.MediaId, 
                  m => m.Id, 
                  (a, m) => new { Assessment = a, Media = m });

        if (!string.IsNullOrWhiteSpace(query.Keyword))
        {
            var keyword = query.Keyword.ToLower();
            queryable = queryable.Where(x => x.Assessment.Question.ToLower().Contains(keyword) || 
                                             x.Media.OriginalFileName.ToLower().Contains(keyword));
        }

        if (!string.IsNullOrWhiteSpace(query.MediaType))
        {
            var mediaType = query.MediaType.ToLower();
            queryable = queryable.Where(x => x.Media.MimeType.ToLower().Contains(mediaType));
        }

        if (query.PublishedAfter.HasValue)
        {
            queryable = queryable.Where(x => x.Assessment.UpdatedAt >= query.PublishedAfter.Value);
        }

        if (query.PublishedBefore.HasValue)
        {
            queryable = queryable.Where(x => x.Assessment.UpdatedAt <= query.PublishedBefore.Value);
        }

        var results = await queryable
            .OrderByDescending(x => x.Assessment.UpdatedAt)
            .Select(x => new LibraryItemSummaryDto(
                x.Assessment.Id,
                x.Assessment.Id,
                x.Assessment.Question,
                x.Media.MimeType,
                x.Assessment.UpdatedAt,
                x.Assessment.Version))
            .ToListAsync(cancellationToken);

        return results;
    }
}
