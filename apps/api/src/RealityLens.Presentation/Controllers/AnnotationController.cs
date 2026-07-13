using System;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using RealityLens.Application.DTOs;
using RealityLens.Application.Interfaces;

namespace RealityLens.Presentation.Controllers;

[ApiController]
[Route("api/annotations")]
public class AnnotationController : ControllerBase
{
    private readonly IAnnotationService _service;

    public AnnotationController(IAnnotationService service)
    {
        _service = service;
    }

    /// <summary>
    /// Returns a single annotation by its ID.
    /// Accessible by Administrator and Teacher.
    /// </summary>
    [HttpGet("{id:guid}")]
    [Authorize(Roles = "Administrator,Teacher")]
    public async Task<IActionResult> GetById(Guid id)
    {
        var result = await _service.GetByIdAsync(id);
        return Ok(result);
    }

    /// <summary>
    /// Returns all annotations belonging to the specified GroundTruth.
    /// Accessible by Administrator and Teacher.
    /// </summary>
    [HttpGet("groundtruth/{groundTruthId:guid}")]
    [Authorize(Roles = "Administrator,Teacher")]
    public async Task<IActionResult> GetByGroundTruth(Guid groundTruthId)
    {
        var userId = Guid.Parse(User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)!.Value);
        var result = await _service.GetByGroundTruthAsync(groundTruthId, userId);
        return Ok(result);
    }

    /// <summary>
    /// Returns all active/draft annotations for a Participant in a Training Session.
    /// Accessible by Participant.
    /// </summary>
    [HttpGet("session/{groundTruthId:guid}/participant")]
    [Authorize(Roles = "Participant")]
    public async Task<IActionResult> GetParticipantAnnotation(Guid groundTruthId)
    {
        var userId = Guid.Parse(User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)!.Value);
        var result = await _service.GetParticipantAnnotationAsync(groundTruthId, userId);
        return Ok(result);
    }


    /// <summary>
    /// Creates a new annotation.
    /// Accessible by Administrator, Teacher and Participant.
    /// </summary>
    [HttpPost]
    [Authorize(Roles = "Administrator,Teacher,Participant")]
    public async Task<IActionResult> Create([FromBody] CreateAnnotationRequest request)
    {
        var userId = Guid.Parse(User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)!.Value);
        var result = await _service.CreateAsync(request, userId);
        return Ok(result);
    }

    /// <summary>
    /// Updates the type and geometry of an existing annotation.
    /// Accessible by Administrator, Teacher and Participant.
    /// </summary>
    [HttpPut("{id:guid}")]
    [Authorize(Roles = "Administrator,Teacher,Participant")]
    public async Task<IActionResult> Update(Guid id, [FromBody] UpdateAnnotationRequest request)
    {
        var userId = Guid.Parse(User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)!.Value);
        var result = await _service.UpdateAsync(id, request, userId);
        return Ok(result);
    }

    /// <summary>
    /// Hard deletes an annotation by its ID.
    /// Accessible by Administrator, Teacher and Participant.
    /// </summary>
    [HttpDelete("{id:guid}")]
    [Authorize(Roles = "Administrator,Teacher,Participant")]
    public async Task<IActionResult> Delete(Guid id)
    {
        var userId = Guid.Parse(User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)!.Value);
        await _service.DeleteAsync(id, userId);
        return NoContent();
    }
}
