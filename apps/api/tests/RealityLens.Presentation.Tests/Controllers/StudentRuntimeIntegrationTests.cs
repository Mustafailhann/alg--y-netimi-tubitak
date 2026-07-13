using FluentAssertions;
using Microsoft.AspNetCore.Mvc.Testing;
using RealityLens.Presentation.Controllers.v1;
using System.Net.Http;
using System.Threading.Tasks;
using Xunit;

namespace RealityLens.Presentation.Tests.Controllers;

public class StudentRuntimeIntegrationTests : IClassFixture<WebApplicationFactory<Program>>
{
    private readonly WebApplicationFactory<Program> _factory;
    private readonly HttpClient _client;

    public StudentRuntimeIntegrationTests(WebApplicationFactory<Program> factory)
    {
        _factory = factory;
        _client = factory.CreateClient();
    }

    [Fact]
    public async Task GetCurrentQuestion_WithoutActiveSession_ReturnsNotFoundOrBadRequest()
    {
        // This validates that the endpoint is reachable but correctly rejects invalid sessions
        var sessionId = System.Guid.NewGuid();
        var response = await _client.GetAsync($"/api/v1/training-sessions/{sessionId}/current-question");

        // The session doesn't exist in the DB, so it should return 404
        response.StatusCode.Should().Be(System.Net.HttpStatusCode.NotFound);
    }
}
