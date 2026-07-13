using System;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using RealityLens.Application.DTOs;
using RealityLens.Application.Interfaces;

namespace RealityLens.Presentation.Controllers;

[ApiController]
[Route("api/assessments/{assessmentId}/groundtruth")]
public class GroundTruthController : ControllerBase
{
    private readonly IGroundTruthService _service;

    public GroundTruthController(IGroundTruthService service)
    {
        _service = service;
    }

    [HttpGet]
    [Authorize(Roles = "Administrator,Teacher")]
    public async Task<IActionResult> GetByAssessmentId(Guid assessmentId)
    {
        return Ok(await _service.GetByAssessmentIdAsync(assessmentId));
    }

    [HttpPost]
    [Authorize(Roles = "Administrator")]
    public async Task<IActionResult> Create(Guid assessmentId, [FromBody] CreateGroundTruthRequest request)
    {
        var result = await _service.CreateAsync(assessmentId, request);
        return Ok(result);
    }

    [HttpPut]
    [Authorize(Roles = "Administrator")]
    public async Task<IActionResult> Update(Guid assessmentId, [FromBody] UpdateGroundTruthRequest request)
    {
        return Ok(await _service.UpdateAsync(assessmentId, request));
    }
}
