using System;
using System.Net;
using System.Net.Http.Json;
using System.Threading.Tasks;
using FluentAssertions;
using Microsoft.AspNetCore.Mvc.Testing;
using RealityLens.Presentation.Controllers.v1;
using Xunit;

namespace RealityLens.Presentation.Tests.Controllers;

public class TrainingPackControllerTests : IClassFixture<WebApplicationFactory<Program>>
{
    private readonly WebApplicationFactory<Program> _factory;

    public TrainingPackControllerTests(WebApplicationFactory<Program> factory)
    {
        // For a true integration test, we might override services to use an In-Memory DB
        // or a test database. We'll use the default setup but test the routing.
        _factory = factory;
    }

    [Fact]
    public async Task Create_ValidRequest_ReturnsCreated()
    {
        // Arrange
        var client = _factory.CreateClient();
        var request = new CreateTrainingPackRequest("Integration Test Pack", Guid.NewGuid(), 45);

        // Act
        var response = await client.PostAsJsonAsync("/api/v1/training-packs", request);

        // Assert
        // Given we don't have authentication mocked here, it might return 401 if Auth is required
        // But our endpoints don't have [Authorize] yet (as per the code).
        response.StatusCode.Should().Be(HttpStatusCode.Created);
        
        var location = response.Headers.Location;
        location.Should().NotBeNull();
    }
}
