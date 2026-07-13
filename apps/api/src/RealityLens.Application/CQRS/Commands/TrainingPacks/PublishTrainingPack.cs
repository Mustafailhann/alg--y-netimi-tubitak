using System;
using System.Threading;
using System.Threading.Tasks;
using FluentValidation;
using RealityLens.Application.CQRS.Interfaces;
using RealityLens.Domain.Repositories;
using Microsoft.Extensions.Logging;

namespace RealityLens.Application.CQRS.Commands.TrainingPacks;

public record PublishTrainingPackCommand(Guid PackId, Guid TeacherId, Guid Version) : ICommand;

public class PublishTrainingPackCommandValidator : AbstractValidator<PublishTrainingPackCommand>
{
    public PublishTrainingPackCommandValidator()
    {
        RuleFor(x => x.PackId).NotEmpty();
        RuleFor(x => x.TeacherId).NotEmpty();
        RuleFor(x => x.Version).NotEmpty();
    }
}

public class PublishTrainingPackCommandHandler : ICommandHandler<PublishTrainingPackCommand>
{
    private readonly ITrainingPackRepository _repository;
    private readonly ILogger<PublishTrainingPackCommandHandler> _logger;

    public PublishTrainingPackCommandHandler(ITrainingPackRepository repository, ILogger<PublishTrainingPackCommandHandler> logger)
    {
        _repository = repository;
        _logger = logger;
    }

    public async Task HandleAsync(PublishTrainingPackCommand command, CancellationToken cancellationToken = default)
    {
        _logger.LogInformation("Started PublishTrainingPack for Pack {PackId}", command.PackId);

        var pack = await _repository.GetByIdAsync(command.PackId, cancellationToken);
        if (pack == null)
        {
            _logger.LogWarning("TrainingPack {PackId} not found.", command.PackId);
            throw new Exception($"TrainingPack {command.PackId} not found.");
        }

        if (pack.TeacherId != command.TeacherId)
        {
            _logger.LogWarning("Teacher {TeacherId} is not authorized to publish Pack {PackId}.", command.TeacherId, command.PackId);
            throw new Exception("Unauthorized.");
        }
        
        if (pack.Version != command.Version)
        {
             _logger.LogWarning("Concurrency conflict detected for Pack {PackId}.", command.PackId);
             throw new Exception("Concurrency conflict.");
        }

        pack.Publish(command.TeacherId);

        await _repository.UpdateAsync(pack, cancellationToken);

        _logger.LogInformation("Completed PublishTrainingPack successfully. PackId: {PackId}", pack.Id);
    }
}
