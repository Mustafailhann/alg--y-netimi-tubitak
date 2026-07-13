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

public class NextQuestionCommandHandlerTests
{
    private RealityLensDbContext CreateContext()
    {
        var options = new DbContextOptionsBuilder<RealityLensDbContext>()
            .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
            .Options;
        return new RealityLensDbContext(options);
    }

    [Fact]
    public async Task HandleAsync_ValidCommand_AdvancesQuestion()
    {
        // Arrange
        var context = CreateContext();

        var packId = Guid.NewGuid();
        var teacherId = Guid.NewGuid();
        
        var joinCode = new RealityLens.Domain.ValueObjects.JoinCode("123456");
        var config = new RealityLens.Domain.ValueObjects.SessionConfiguration(null, false, false, false, false, false, null);
        
        var session = new TrainingSession(packId, teacherId, joinCode, config);
        session.Start(teacherId);
        
        context.TrainingSessions.Add(session);

        var trainingItem1 = new TrainingItem(packId, Guid.NewGuid(), 0);
        var trainingItem2 = new TrainingItem(packId, Guid.NewGuid(), 1);
        context.TrainingItems.AddRange(trainingItem1, trainingItem2);

        await context.SaveChangesAsync();

        var handler = new NextQuestionCommandHandler(context);
        var command = new NextQuestionCommand(session.Id, teacherId);

        // Act
        await handler.HandleAsync(command, CancellationToken.None);

        // Assert
        var updatedSession = await context.TrainingSessions.FirstAsync();
        updatedSession.CurrentQuestionIndex.Should().Be(1);
    }

    [Fact]
    public async Task HandleAsync_NotTeacher_ThrowsException()
    {
        // Arrange
        var context = CreateContext();
        var packId = Guid.NewGuid();
        var teacherId = Guid.NewGuid();
        var wrongTeacherId = Guid.NewGuid();
        var joinCode = new RealityLens.Domain.ValueObjects.JoinCode("123456");
        var config = new RealityLens.Domain.ValueObjects.SessionConfiguration(null, false, false, false, false, false, null);
        var session = new TrainingSession(packId, teacherId, joinCode, config);
        session.Start(teacherId);
        
        context.TrainingSessions.Add(session);
        await context.SaveChangesAsync();

        var handler = new NextQuestionCommandHandler(context);
        var command = new NextQuestionCommand(session.Id, wrongTeacherId);

        // Act
        Func<Task> act = async () => await handler.HandleAsync(command, CancellationToken.None);

        // Assert
        await act.Should().ThrowAsync<Exception>().WithMessage("Unauthorized. Only the teacher who created the session can advance questions.");
    }
}
