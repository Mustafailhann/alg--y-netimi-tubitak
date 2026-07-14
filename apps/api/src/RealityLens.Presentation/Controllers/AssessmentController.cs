using System;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using RealityLens.Application.DTOs;
using RealityLens.Application.Interfaces;

namespace RealityLens.Presentation.Controllers;

[ApiController]
[Route("api/assessments")]
public class AssessmentController : ControllerBase
{
    private readonly IAssessmentService _service;

    public AssessmentController(IAssessmentService service)
    {
        _service = service;
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

    [HttpPost]
    [Authorize(Roles = "Administrator,Teacher")]
    public async Task<IActionResult> Create([FromBody] CreateAssessmentRequest request)
    {
        var result = await _service.CreateAsync(request);
        return CreatedAtAction(nameof(GetById), new { id = result.Id }, result);
    }

    [HttpPut("{id}")]
    [Authorize(Roles = "Administrator,Teacher")]
    public async Task<IActionResult> Update(Guid id, [FromBody] UpdateAssessmentRequest request)
    {
        return Ok(await _service.UpdateAsync(id, request));
    }

    [HttpPut("{id}/ready")]
    [Authorize(Roles = "Administrator,Teacher")]
    public async Task<IActionResult> MarkReady(Guid id)
    {
        await _service.MarkReadyAsync(id);
        return NoContent();
    }

    [HttpPut("{id}/publish")]
    [Authorize(Roles = "Administrator,Teacher")]
    public async Task<IActionResult> Publish(Guid id)
    {
        await _service.PublishAsync(id);
        return NoContent();
    }

    [HttpPut("{id}/archive")]
    [Authorize(Roles = "Administrator,Teacher")]
    public async Task<IActionResult> Archive(Guid id)
    {
        await _service.ArchiveAsync(id);
        return NoContent();
    }
}
