using System;
using System.Threading;
using System.Threading.Tasks;
using FluentValidation;
using RealityLens.Application.CQRS.Interfaces;
using RealityLens.Domain.Entities;
using RealityLens.Domain.Enums;
using RealityLens.Domain.Repositories;
using RealityLens.Domain.ValueObjects;
using Microsoft.Extensions.Logging;

namespace RealityLens.Application.CQRS.Commands.TrainingSessions;

public record CreateTrainingSessionCommand(
    Guid PackId, 
    Guid TeacherId, 
    int? TimeLimitMinutes, 
    bool RandomQuestionOrder, 
    bool AllowRetry, 
    bool ShowImmediateFeedback, 
    bool LeaderboardEnabled, 
    bool CanvasRequired, 
    int? MaximumAttempts) : ICommand<Guid>;

public class CreateTrainingSessionCommandValidator : AbstractValidator<CreateTrainingSessionCommand>
{
    public CreateTrainingSessionCommandValidator()
    {
        RuleFor(x => x.PackId).NotEmpty();
        RuleFor(x => x.TeacherId).NotEmpty();
        RuleFor(x => x.TimeLimitMinutes).GreaterThan(0).When(x => x.TimeLimitMinutes.HasValue);
        RuleFor(x => x.MaximumAttempts).GreaterThan(0).When(x => x.MaximumAttempts.HasValue);
    }
}

public class CreateTrainingSessionCommandHandler : ICommandHandler<CreateTrainingSessionCommand, Guid>
{
    private readonly ITrainingSessionRepository _sessionRepository;
    private readonly ITrainingPackRepository _packRepository;
    private readonly ILogger<CreateTrainingSessionCommandHandler> _logger;

    public CreateTrainingSessionCommandHandler(
        ITrainingSessionRepository sessionRepository, 
        ITrainingPackRepository packRepository,
        ILogger<CreateTrainingSessionCommandHandler> logger)
    {
        _sessionRepository = sessionRepository;
        _packRepository = packRepository;
        _logger = logger;
    }

    public async Task<Guid> HandleAsync(CreateTrainingSessionCommand command, CancellationToken cancellationToken = default)
    {
        _logger.LogInformation("Started CreateTrainingSession for Pack {PackId} by Teacher {TeacherId}", command.PackId, command.TeacherId);

        var pack = await _packRepository.GetByIdAsync(command.PackId, cancellationToken);
        if (pack == null)
            throw new Exception($"TrainingPack {command.PackId} not found.");

        if (pack.Status != TrainingPackStatus.Published)
            throw new InvalidOperationException("Can only create sessions for published training packs.");

        // Generate a random 6 character join code
        var random = new Random();
        const string chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        var joinCodeStr = new string(System.Linq.Enumerable.Repeat(chars, 6).Select(s => s[random.Next(s.Length)]).ToArray());
        var joinCode = new JoinCode(joinCodeStr);

        var config = new SessionConfiguration(
            command.TimeLimitMinutes,
            command.RandomQuestionOrder,
            command.AllowRetry,
            command.ShowImmediateFeedback,
            command.LeaderboardEnabled,
            command.CanvasRequired,
            command.MaximumAttempts
        );

        var session = new TrainingSession(command.PackId, command.TeacherId, joinCode, config);

        await _sessionRepository.AddAsync(session, cancellationToken);

        _logger.LogInformation("Completed CreateTrainingSession successfully. SessionId: {SessionId}, JoinCode: {JoinCode}", session.Id, joinCodeStr);

        return session.Id;
    }
}
