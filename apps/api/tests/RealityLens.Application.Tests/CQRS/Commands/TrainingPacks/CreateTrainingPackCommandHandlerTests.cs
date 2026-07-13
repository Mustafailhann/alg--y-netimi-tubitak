using System;
using System.Threading;
using System.Threading.Tasks;
using FluentAssertions;
using Microsoft.Extensions.Logging;
using Moq;
using RealityLens.Application.CQRS.Commands.TrainingPacks;
using RealityLens.Domain.Entities;
using RealityLens.Domain.Repositories;
using Xunit;

namespace RealityLens.Application.Tests.CQRS.Commands.TrainingPacks;

public class CreateTrainingPackCommandHandlerTests
{
    private readonly Mock<ITrainingPackRepository> _repositoryMock;
    private readonly Mock<ILogger<CreateTrainingPackCommandHandler>> _loggerMock;
    private readonly CreateTrainingPackCommandHandler _handler;

    public CreateTrainingPackCommandHandlerTests()
    {
        _repositoryMock = new Mock<ITrainingPackRepository>();
        _loggerMock = new Mock<ILogger<CreateTrainingPackCommandHandler>>();
        _handler = new CreateTrainingPackCommandHandler(_repositoryMock.Object, _loggerMock.Object);
    }

    [Fact]
    public async Task HandleAsync_ValidCommand_CreatesTrainingPack()
    {
        // Arrange
        var command = new CreateTrainingPackCommand(Guid.NewGuid(), "Test Pack", 60);

        // Act
        var resultId = await _handler.HandleAsync(command, CancellationToken.None);

        // Assert
        resultId.Should().NotBeEmpty();
        _repositoryMock.Verify(x => x.AddAsync(It.Is<TrainingPack>(p => 
            p.Id == resultId &&
            p.Title == command.Title &&
            p.TeacherId == command.TeacherId &&
            p.EstimatedDuration == command.EstimatedDuration
        ), It.IsAny<CancellationToken>()), Times.Once);
    }
}
