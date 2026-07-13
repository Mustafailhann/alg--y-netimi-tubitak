using Asp.Versioning;
using Microsoft.AspNetCore.Mvc;
using RealityLens.Application.CQRS.Interfaces;
using RealityLens.Application.CQRS.Queries.TrainingLibrary;
using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace RealityLens.Presentation.Controllers.v1;

[ApiController]
[ApiVersion("1.0")]
[Route("api/v{version:apiVersion}/training-library")]
public class TrainingLibraryController : ControllerBase
{
    private readonly IQueryDispatcher _queryDispatcher;

    public TrainingLibraryController(IQueryDispatcher queryDispatcher)
    {
        _queryDispatcher = queryDispatcher;
    }

    [HttpGet]
    public async Task<ActionResult<IEnumerable<LibraryItemSummaryDto>>> SearchLibraryItems(
        [FromQuery] string? keyword,
        [FromQuery] string? difficulty,
        [FromQuery] string? manipulationType,
        [FromQuery] string? mediaType,
        [FromQuery] List<string>? tags,
        [FromQuery] DateTime? publishedAfter,
        [FromQuery] DateTime? publishedBefore,
        CancellationToken cancellationToken)
    {
        var query = new SearchLibraryItemsQuery(keyword, difficulty, manipulationType, mediaType, tags, publishedAfter, publishedBefore);
        var result = await _queryDispatcher.DispatchAsync<SearchLibraryItemsQuery, IEnumerable<LibraryItemSummaryDto>>(query, cancellationToken);
        return Ok(result);
    }

    [HttpGet("{id:guid}")]
    public async Task<ActionResult<LibraryItemDetailDto>> GetLibraryItemById(Guid id, CancellationToken cancellationToken)
    {
        var query = new GetLibraryItemByIdQuery(id);
        var result = await _queryDispatcher.DispatchAsync<GetLibraryItemByIdQuery, LibraryItemDetailDto?>(query, cancellationToken);
        
        if (result == null)
            return NotFound();
            
        return Ok(result);
    }
}
