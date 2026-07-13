using FluentAssertions;
using Microsoft.EntityFrameworkCore;
using RealityLens.Application.CQRS.Commands.TrainingSessions;
using RealityLens.Domain.Entities;
using RealityLens.Domain.Enums;
using RealityLens.Persistence;
using System;
using System.Threading;
using System.Threading.Tasks;
using Xunit;

namespace RealityLens.Application.Tests.CQRS.Commands.TrainingSessions;

public class ParticipantHeartbeatCommandHandlerTests
{
    private RealityLensDbContext CreateContext()
    {
        var options = new DbContextOptionsBuilder<RealityLensDbContext>()
            .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
            .Options;
        return new RealityLensDbContext(options);
    }

    [Fact]
    public async Task HandleAsync_ValidParticipant_UpdatesHeartbeat()
    {
        // Arrange
        var context = CreateContext();

        var packId = Guid.NewGuid();
        var teacherId = Guid.NewGuid();
        var joinCode = new RealityLens.Domain.ValueObjects.JoinCode("123456");
        var config = new RealityLens.Domain.ValueObjects.SessionConfiguration(null, false, false, false, false, false, null);
        var session = new TrainingSession(packId, teacherId, joinCode, config);
        session.Start(teacherId);

        var participant = new Participant(session.Id, "student1");
        participant.Leave(); // to ensure it changes back to Online
        session.AddParticipant(participant);

        context.TrainingSessions.Add(session);
        await context.SaveChangesAsync();

        var handler = new ParticipantHeartbeatCommandHandler(context);
        var command = new ParticipantHeartbeatCommand(session.Id, participant.Id);

        var previousHeartbeat = participant.LastHeartbeatAt;

        // Act
        await handler.HandleAsync(command, CancellationToken.None);

        // Assert
        var updatedParticipant = await context.Participants.FirstAsync();
        updatedParticipant.LastHeartbeatAt.Should().BeAfter(previousHeartbeat ?? DateTime.MinValue);
    }
}
