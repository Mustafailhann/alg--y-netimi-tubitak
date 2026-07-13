using FluentAssertions;
using Microsoft.EntityFrameworkCore;
using RealityLens.Application.CQRS.Commands.TrainingSessions;
using RealityLens.Domain.Entities;
using RealityLens.Persistence;
using System;
using Moq;
using System.Threading;
using System.Threading.Tasks;
using Xunit;

namespace RealityLens.Application.Tests.CQRS.Commands.TrainingSessions;

public class AddParticipantCommandHandlerTests
{
    private RealityLensDbContext CreateContext()
    {
        var options = new DbContextOptionsBuilder<RealityLensDbContext>()
            .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
            .Options;
        return new RealityLensDbContext(options);
    }

    [Fact]
    public async Task HandleAsync_InvalidJoinCode_ThrowsException()
    {
        // Arrange
        var mockRepo = new Mock<RealityLens.Domain.Repositories.ITrainingSessionRepository>();
        mockRepo.Setup(r => r.GetByJoinCodeAsync(It.IsAny<RealityLens.Domain.ValueObjects.JoinCode>(), It.IsAny<CancellationToken>()))
                .ReturnsAsync((TrainingSession)null);
                
        var tokenServiceMock = new Mock<RealityLens.Application.Interfaces.ITokenService>();
        var loggerMock = new Mock<Microsoft.Extensions.Logging.ILogger<AddParticipantCommandHandler>>();
        var handler = new AddParticipantCommandHandler(mockRepo.Object, tokenServiceMock.Object, loggerMock.Object);
        var command = new AddParticipantCommand("INVLD1", "student1");

        // Act
        Func<Task> act = async () => await handler.HandleAsync(command, CancellationToken.None);

        // Assert
        await act.Should().ThrowAsync<Exception>().WithMessage("*not found*");
    }
}
