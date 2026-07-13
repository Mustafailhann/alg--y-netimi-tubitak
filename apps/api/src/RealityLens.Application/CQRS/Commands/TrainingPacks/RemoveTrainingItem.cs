using System;
using System.Threading;
using System.Threading.Tasks;
using FluentValidation;
using RealityLens.Application.CQRS.Interfaces;
using RealityLens.Domain.Repositories;
using Microsoft.Extensions.Logging;

namespace RealityLens.Application.CQRS.Commands.TrainingPacks;

public record RemoveTrainingItemCommand(Guid PackId, Guid TeacherId, Guid TrainingItemId, Guid Version) : ICommand;

public class RemoveTrainingItemCommandValidator : AbstractValidator<RemoveTrainingItemCommand>
{
    public RemoveTrainingItemCommandValidator()
    {
        RuleFor(x => x.PackId).NotEmpty();
        RuleFor(x => x.TeacherId).NotEmpty();
        RuleFor(x => x.TrainingItemId).NotEmpty();
        RuleFor(x => x.Version).NotEmpty();
    }
}

public class RemoveTrainingItemCommandHandler : ICommandHandler<RemoveTrainingItemCommand>
{
    private readonly ITrainingPackRepository _repository;
    private readonly ILogger<RemoveTrainingItemCommandHandler> _logger;

    public RemoveTrainingItemCommandHandler(ITrainingPackRepository repository, ILogger<RemoveTrainingItemCommandHandler> logger)
    {
        _repository = repository;
        _logger = logger;
    }

    public async Task HandleAsync(RemoveTrainingItemCommand command, CancellationToken cancellationToken = default)
    {
        _logger.LogInformation("Started RemoveTrainingItem for Pack {PackId}", command.PackId);

        var pack = await _repository.GetByIdAsync(command.PackId, cancellationToken);
        if (pack == null)
        {
            _logger.LogWarning("TrainingPack {PackId} not found.", command.PackId);
            throw new Exception($"TrainingPack {command.PackId} not found.");
        }

        if (pack.TeacherId != command.TeacherId)
        {
            _logger.LogWarning("Teacher {TeacherId} is not authorized to remove item from Pack {PackId}.", command.TeacherId, command.PackId);
            throw new Exception("Unauthorized.");
        }
        
        if (pack.Version != command.Version)
        {
             _logger.LogWarning("Concurrency conflict detected for Pack {PackId}.", command.PackId);
             throw new Exception("Concurrency conflict.");
        }

        pack.RemoveTrainingItem(command.TrainingItemId);

        await _repository.UpdateAsync(pack, cancellationToken);

        _logger.LogInformation("Completed RemoveTrainingItem successfully.");
    }
}
