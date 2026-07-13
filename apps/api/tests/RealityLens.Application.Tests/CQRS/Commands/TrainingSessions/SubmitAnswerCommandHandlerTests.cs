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

public class SubmitAnswerCommandHandlerTests
{
    private RealityLensDbContext CreateContext()
    {
        var options = new DbContextOptionsBuilder<RealityLensDbContext>()
            .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
            .Options;
        return new RealityLensDbContext(options);
    }

    [Fact]
    public async Task HandleAsync_ValidAnswer_SavesAndReturnsAnswerId()
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
        session.AddParticipant(participant);

        context.TrainingSessions.Add(session);

        var trainingItem = new TrainingItem(packId, Guid.NewGuid(), 0);
        context.TrainingItems.Add(trainingItem);

        await context.SaveChangesAsync();

        var mockScoringService = new Moq.Mock<RealityLens.Application.Interfaces.IScoringService>();
        var handler = new SubmitAnswerCommandHandler(context, mockScoringService.Object);
        var command = new SubmitAnswerCommand(session.Id, participant.Id, Judgment.Real, 100, new List<Guid> { Guid.NewGuid() });

        // Act
        var answerId = await handler.HandleAsync(command, CancellationToken.None);

        // Assert
        answerId.Should().NotBeEmpty();

        var savedAnswer = await context.ParticipantAnswers.FirstOrDefaultAsync();
        savedAnswer.Should().NotBeNull();
        savedAnswer.ParticipantId.Should().Be(participant.Id);
        savedAnswer.TrainingSessionId.Should().Be(session.Id);
        savedAnswer.Judgment.Should().Be(Judgment.Real);
        
        var updatedParticipant = await context.Participants.FirstAsync();
        updatedParticipant.ProgressPercentage.Should().BeGreaterThan(0);
    }

    [Fact]
    public async Task HandleAsync_AlreadyAnswered_ThrowsException()
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
        session.AddParticipant(participant);

        context.TrainingSessions.Add(session);

        var trainingItem = new TrainingItem(packId, Guid.NewGuid(), 0);
        context.TrainingItems.Add(trainingItem);

        var existingAnswer = new ParticipantAnswer(session.Id, participant.Id, trainingItem.Id, trainingItem.AssessmentId, Judgment.Real, false, 100);
        context.ParticipantAnswers.Add(existingAnswer);

        await context.SaveChangesAsync();

        var mockScoringService = new Moq.Mock<RealityLens.Application.Interfaces.IScoringService>();
        var handler = new SubmitAnswerCommandHandler(context, mockScoringService.Object);
        var command = new SubmitAnswerCommand(session.Id, participant.Id, Judgment.Real, 100, new List<Guid> { Guid.NewGuid() });

        // Act
        Func<Task> act = async () => await handler.HandleAsync(command, CancellationToken.None);

        // Assert
        await act.Should().ThrowAsync<Exception>().WithMessage("Participant already answered this question.");
    }

    [Fact]
    public async Task HandleAsync_SessionFinished_ThrowsException()
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
        session.AddParticipant(participant);

        session.FinishSession(teacherId); // End the session after participant joins

        context.TrainingSessions.Add(session);
        await context.SaveChangesAsync();

        var mockScoringService = new Moq.Mock<RealityLens.Application.Interfaces.IScoringService>();
        var handler = new SubmitAnswerCommandHandler(context, mockScoringService.Object);
        var command = new SubmitAnswerCommand(session.Id, participant.Id, Judgment.Real, 100, new List<Guid> { Guid.NewGuid() });

        // Act
        Func<Task> act = async () => await handler.HandleAsync(command, CancellationToken.None);

        // Assert
        await act.Should().ThrowAsync<Exception>().WithMessage("Session is not active.");
    }
}
