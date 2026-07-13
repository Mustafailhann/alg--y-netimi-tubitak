using Microsoft.AspNetCore.Mvc;

namespace RealityLens.Presentation.Controllers;

[ApiController]
[Route("health")]
public sealed class HealthController : ControllerBase
{
    [HttpGet]
    [ProducesResponseType(StatusCodes.Status200OK)]
    public IActionResult Get()
    {
        return Ok(new
        {
            Status = "Healthy",
            Service = "RealityLens API",
            Timestamp = DateTime.UtcNow,
            Version = "0.1.0"
        });
    }
}
