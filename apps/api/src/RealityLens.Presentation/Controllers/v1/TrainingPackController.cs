using Asp.Versioning;
using Microsoft.AspNetCore.Mvc;
using RealityLens.Application.CQRS.Commands.TrainingPacks;
using RealityLens.Application.CQRS.Interfaces;
using RealityLens.Application.CQRS.Queries.TrainingPacks;
using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;

namespace RealityLens.Presentation.Controllers.v1;

[ApiController]
[ApiVersion("1.0")]
[Route("api/v{version:apiVersion}/training-packs")]
[Authorize]
public class TrainingPackController : ControllerBase
{
    private readonly ICommandDispatcher _commandDispatcher;
    private readonly IQueryDispatcher _queryDispatcher;

    public TrainingPackController(ICommandDispatcher commandDispatcher, IQueryDispatcher queryDispatcher)
    {
        _commandDispatcher = commandDispatcher;
        _queryDispatcher = queryDispatcher;
    }

    [HttpGet]
    public async Task<ActionResult<IEnumerable<TrainingPackDto>>> GetMyPacks(
        [FromQuery] Guid teacherId, // In real app, from claims
        CancellationToken cancellationToken)
    {
        var query = new GetTrainingPacksByTeacherQuery(teacherId);
        var result = await _queryDispatcher.DispatchAsync<GetTrainingPacksByTeacherQuery, IEnumerable<TrainingPackDto>>(query, cancellationToken);
        return Ok(result);
    }

    [HttpGet("{id:guid}")]
    public async Task<ActionResult<TrainingPackDetailDto>> GetById(
        Guid id,
        [FromQuery] Guid teacherId, // In real app, from claims
        CancellationToken cancellationToken)
    {
        var query = new GetTrainingPackByIdQuery(id, teacherId);
        var result = await _queryDispatcher.DispatchAsync<GetTrainingPackByIdQuery, TrainingPackDetailDto?>(query, cancellationToken);
        
        if (result == null)
            return NotFound();
            
        return Ok(result);
    }

    [HttpGet("{id:guid}/items")]
    public async Task<ActionResult<IEnumerable<TrainingItemDto>>> GetPackItems(
        Guid id,
        [FromQuery] Guid teacherId, // In real app, from claims
        CancellationToken cancellationToken)
    {
        var query = new GetTrainingPackItemsQuery(id, teacherId);
        var result = await _queryDispatcher.DispatchAsync<GetTrainingPackItemsQuery, IEnumerable<TrainingItemDto>>(query, cancellationToken);
        return Ok(result);
    }

    [HttpPost]
    public async Task<ActionResult> Create(
        [FromBody] CreateTrainingPackRequest request,
        CancellationToken cancellationToken)
    {
        // teacherId from claims normally
        var command = new CreateTrainingPackCommand(request.TeacherId, request.Title, request.EstimatedDuration);
        var packId = await _commandDispatcher.DispatchAsync<CreateTrainingPackCommand, Guid>(command, cancellationToken);
        return CreatedAtAction(nameof(GetById), new { id = packId, teacherId = request.TeacherId }, new { id = packId });
    }

    [HttpPut("{id:guid}")]
    public async Task<ActionResult> Update(
        Guid id,
        [FromBody] UpdateTrainingPackRequest request,
        CancellationToken cancellationToken)
    {
        var command = new UpdateTrainingPackCommand(id, request.TeacherId, request.Title, request.EstimatedDuration, request.Version);
        await _commandDispatcher.DispatchAsync(command, cancellationToken);
        return NoContent();
    }

    [HttpPost("{id:guid}/archive")]
    public async Task<ActionResult> Archive(
        Guid id,
        [FromBody] ArchiveTrainingPackRequest request,
        CancellationToken cancellationToken)
    {
        var command = new ArchiveTrainingPackCommand(id, request.TeacherId, request.Version);
        await _commandDispatcher.DispatchAsync(command, cancellationToken);
        return NoContent();
    }

    [HttpPost("{id:guid}/publish")]
    public async Task<ActionResult> Publish(
        Guid id,
        [FromBody] PublishTrainingPackRequest request,
        CancellationToken cancellationToken)
    {
        var command = new PublishTrainingPackCommand(id, request.TeacherId, request.Version);
        await _commandDispatcher.DispatchAsync(command, cancellationToken);
        return NoContent();
    }

    [HttpPost("{id:guid}/items")]
    public async Task<ActionResult> AddItem(
        Guid id,
        [FromBody] AddTrainingItemRequest request,
        CancellationToken cancellationToken)
    {
        var command = new AddTrainingItemCommand(id, request.TeacherId, request.LibraryItemId, request.OrderIndex, request.Version);
        var itemId = await _commandDispatcher.DispatchAsync<AddTrainingItemCommand, Guid>(command, cancellationToken);
        return Ok(new { id = itemId });
    }

    [HttpDelete("{id:guid}/items/{itemId:guid}")]
    public async Task<ActionResult> RemoveItem(
        Guid id,
        Guid itemId,
        [FromBody] RemoveTrainingItemRequest request,
        CancellationToken cancellationToken)
    {
        var command = new RemoveTrainingItemCommand(id, request.TeacherId, itemId, request.Version);
        await _commandDispatcher.DispatchAsync(command, cancellationToken);
        return NoContent();
    }

    [HttpPost("{id:guid}/items/reorder")]
    public async Task<ActionResult> ReorderItems(
        Guid id,
        [FromBody] ReorderTrainingItemsRequest request,
        CancellationToken cancellationToken)
    {
        var command = new ReorderTrainingItemsCommand(id, request.TeacherId, request.OrderedItemIds, request.Version);
        await _commandDispatcher.DispatchAsync(command, cancellationToken);
        return NoContent();
    }
}

// Request DTOs
public record CreateTrainingPackRequest(string Title, Guid TeacherId, int? EstimatedDuration);
public record UpdateTrainingPackRequest(string Title, Guid TeacherId, int? EstimatedDuration, Guid Version);
public record ArchiveTrainingPackRequest(Guid TeacherId, Guid Version);
public record PublishTrainingPackRequest(Guid TeacherId, Guid Version);
public record AddTrainingItemRequest(Guid TeacherId, Guid LibraryItemId, int OrderIndex, Guid Version);
public record RemoveTrainingItemRequest(Guid TeacherId, Guid Version);
public record ReorderTrainingItemsRequest(Guid TeacherId, List<Guid> OrderedItemIds, Guid Version);
