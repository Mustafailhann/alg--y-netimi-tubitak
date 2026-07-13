using System;
using System.Threading;
using System.Threading.Tasks;
using FluentValidation;
using RealityLens.Application.CQRS.Interfaces;
using RealityLens.Domain.Repositories;
using Microsoft.Extensions.Logging;

namespace RealityLens.Application.CQRS.Commands.TrainingSessions;

public record CompleteTrainingSessionCommand(Guid SessionId, Guid TeacherId, Guid Version) : ICommand;

public class CompleteTrainingSessionCommandValidator : AbstractValidator<CompleteTrainingSessionCommand>
{
    public CompleteTrainingSessionCommandValidator()
    {
        RuleFor(x => x.SessionId).NotEmpty();
        RuleFor(x => x.TeacherId).NotEmpty();
        RuleFor(x => x.Version).NotEmpty();
    }
}

public class CompleteTrainingSessionCommandHandler : ICommandHandler<CompleteTrainingSessionCommand>
{
    private readonly ITrainingSessionRepository _repository;
    private readonly ILogger<CompleteTrainingSessionCommandHandler> _logger;

    public CompleteTrainingSessionCommandHandler(ITrainingSessionRepository repository, ILogger<CompleteTrainingSessionCommandHandler> logger)
    {
        _repository = repository;
        _logger = logger;
    }

    public async Task HandleAsync(CompleteTrainingSessionCommand command, CancellationToken cancellationToken = default)
    {
        _logger.LogInformation("Started CompleteTrainingSession for Session {SessionId}", command.SessionId);

        var session = await _repository.GetByIdAsync(command.SessionId, cancellationToken);
        if (session == null)
            throw new Exception($"TrainingSession {command.SessionId} not found.");

        if (session.CreatedBy != command.TeacherId)
            throw new Exception("Unauthorized.");

        if (session.Version != command.Version)
            throw new Exception("Concurrency conflict.");

        session.End(command.TeacherId);

        await _repository.UpdateAsync(session, cancellationToken);

        _logger.LogInformation("Completed CompleteTrainingSession successfully.");
    }
}
