using FluentAssertions;
using Microsoft.EntityFrameworkCore;
using RealityLens.Application.CQRS.Queries.TrainingSessions;
using RealityLens.Domain.Entities;
using RealityLens.Domain.Enums;
using RealityLens.Persistence;
using System;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Xunit;

namespace RealityLens.Application.Tests.CQRS.Queries.TrainingSessions;

public class GetTrainingSessionParticipantsQueryHandlerTests
{
    private RealityLensDbContext CreateContext()
    {
        var options = new DbContextOptionsBuilder<RealityLensDbContext>()
            .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
            .Options;
        return new RealityLensDbContext(options);
    }

    [Fact]
    public async Task HandleAsync_HeartbeatTimeout_ReturnsOffline()
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
        
        // Simulate a heartbeat 35 seconds ago
        var pastTime = DateTime.UtcNow.AddSeconds(-35);
        participant.GetType().GetProperty("LastHeartbeatAt").SetValue(participant, pastTime);
        
        session.AddParticipant(participant);

        context.TrainingSessions.Add(session);
        await context.SaveChangesAsync();

        var handler = new GetTrainingSessionParticipantsQueryHandler(context);
        var query = new GetTrainingSessionParticipantsQuery(session.Id, teacherId);

        // Act
        var result = await handler.HandleAsync(query, CancellationToken.None);

        // Assert
        result.Should().HaveCount(1);
        result.First().ConnectionStatus.Should().Be(ConnectionStatus.Offline);
    }
}
