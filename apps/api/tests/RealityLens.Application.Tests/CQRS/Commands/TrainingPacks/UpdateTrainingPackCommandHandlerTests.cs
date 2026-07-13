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

public class UpdateTrainingPackCommandHandlerTests
{
    private readonly Mock<ITrainingPackRepository> _repositoryMock;
    private readonly Mock<ILogger<UpdateTrainingPackCommandHandler>> _loggerMock;
    private readonly UpdateTrainingPackCommandHandler _handler;

    public UpdateTrainingPackCommandHandlerTests()
    {
        _repositoryMock = new Mock<ITrainingPackRepository>();
        _loggerMock = new Mock<ILogger<UpdateTrainingPackCommandHandler>>();
        _handler = new UpdateTrainingPackCommandHandler(_repositoryMock.Object, _loggerMock.Object);
    }

    [Fact]
    public async Task HandleAsync_ValidCommand_UpdatesTrainingPack()
    {
        // Arrange
        var teacherId = Guid.NewGuid();
        var pack = new TrainingPack(teacherId, "Old Title", 30);
        var command = new UpdateTrainingPackCommand(pack.Id, teacherId, "New Title", 60, pack.Version);

        _repositoryMock.Setup(x => x.GetByIdAsync(pack.Id, It.IsAny<CancellationToken>()))
            .ReturnsAsync(pack);

        // Act
        await _handler.HandleAsync(command, CancellationToken.None);

        // Assert
        pack.Title.Should().Be("New Title");
        pack.EstimatedDuration.Should().Be(60);
        _repositoryMock.Verify(x => x.UpdateAsync(pack, It.IsAny<CancellationToken>()), Times.Once);
    }

    [Fact]
    public async Task HandleAsync_ConcurrencyConflict_ThrowsException()
    {
        // Arrange
        var teacherId = Guid.NewGuid();
        var pack = new TrainingPack(teacherId, "Old Title", 30);
        var wrongVersion = Guid.NewGuid(); // different version
        var command = new UpdateTrainingPackCommand(pack.Id, teacherId, "New Title", 60, wrongVersion);

        _repositoryMock.Setup(x => x.GetByIdAsync(pack.Id, It.IsAny<CancellationToken>()))
            .ReturnsAsync(pack);

        // Act & Assert
        await Assert.ThrowsAsync<Exception>(() => _handler.HandleAsync(command, CancellationToken.None));
        _repositoryMock.Verify(x => x.UpdateAsync(It.IsAny<TrainingPack>(), It.IsAny<CancellationToken>()), Times.Never);
    }
}
