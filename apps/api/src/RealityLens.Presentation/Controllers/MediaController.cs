using System;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http;
using RealityLens.Application.DTOs;
using RealityLens.Application.Interfaces;

namespace RealityLens.Presentation.Controllers;

[ApiController]
[Route("api/media")]
public class MediaController : ControllerBase
{
    private readonly IMediaService _service;
    private readonly IStorageService _storageService;

    public MediaController(IMediaService service, IStorageService storageService)
    {
        _service = service;
        _storageService = storageService;
    }

    [HttpGet]
    [Authorize(Roles = "Administrator,Teacher")]
    public async Task<IActionResult> GetAll()
    {
        return Ok(await _service.GetAllAsync());
    }

    [HttpGet("{id}")]
    [Authorize(Roles = "Administrator,Teacher")]
    public async Task<IActionResult> GetById(Guid id)
    {
        return Ok(await _service.GetByIdAsync(id));
    }

    [HttpGet("{id}/preview")]
    [Authorize(Roles = "Administrator,Teacher")]
    public async Task<IActionResult> GetPreview(Guid id)
    {
        var media = await _service.GetByIdAsync(id);
        if (media.StoragePath.StartsWith("http", StringComparison.OrdinalIgnoreCase))
            return Redirect(media.StoragePath);

        var path = _storageService.GetPhysicalPath(media.StoragePath);
        if (!System.IO.File.Exists(path)) return NotFound();
        return PhysicalFile(path, media.MimeType, enableRangeProcessing: true);
    }

    [HttpGet("{id}/thumbnail")]
    [Authorize(Roles = "Administrator,Teacher")]
    public async Task<IActionResult> GetThumbnail(Guid id)
    {
        var media = await _service.GetByIdAsync(id);
        if (string.IsNullOrWhiteSpace(media.ThumbnailPath)) return NotFound();

        if (media.ThumbnailPath.StartsWith("http", StringComparison.OrdinalIgnoreCase))
            return Redirect(media.ThumbnailPath);

        var path = _storageService.GetPhysicalPath(media.ThumbnailPath);
        if (!System.IO.File.Exists(path)) return NotFound();
        
        string mimeType = media.ThumbnailPath.EndsWith(".webp") ? "image/webp" : "image/jpeg";
        return PhysicalFile(path, mimeType);
    }

    [HttpPost("upload")]
    [Authorize]
    [DisableRequestSizeLimit]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<IActionResult> Upload(IFormFile file)
    {
        if (file == null || file.Length == 0)
            return BadRequest(new { error = "No file provided." });

        var userIdString = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
        if (!Guid.TryParse(userIdString, out Guid userId))
            return Unauthorized();

        using var stream = file.OpenReadStream();

        var request = new UploadMediaRequest
        {
            Content = stream,
            OriginalFileName = file.FileName,
            ContentType = file.ContentType,
            FileSize = file.Length,
            UploadedByUserId = userId
        };

        var result = await _service.UploadAsync(request);
        return CreatedAtAction(nameof(GetById), new { id = result.Id }, result);
    }

    [HttpPost("{id}/reprocess")]
    [Authorize(Roles = "Administrator")]
    public async Task<IActionResult> Reprocess(Guid id)
    {
        try
        {
            var result = await _service.ReprocessAsync(id);
            return Ok(result);
        }
        catch (InvalidOperationException ex)
        {
            return Conflict(new { error = ex.Message });
        }
    }

    [HttpDelete("{id}")]
    [Authorize(Roles = "Administrator")]
    public async Task<IActionResult> Delete(Guid id)
    {
        await _service.DeleteAsync(id);
        return NoContent();
    }
}
