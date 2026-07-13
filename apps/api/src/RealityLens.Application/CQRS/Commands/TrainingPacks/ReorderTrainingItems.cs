using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using FluentValidation;
using RealityLens.Application.CQRS.Interfaces;
using RealityLens.Domain.Repositories;
using Microsoft.Extensions.Logging;

namespace RealityLens.Application.CQRS.Commands.TrainingPacks;

public record ReorderTrainingItemsCommand(Guid PackId, Guid TeacherId, List<Guid> OrderedItemIds, Guid Version) : ICommand;

public class ReorderTrainingItemsCommandValidator : AbstractValidator<ReorderTrainingItemsCommand>
{
    public ReorderTrainingItemsCommandValidator()
    {
        RuleFor(x => x.PackId).NotEmpty();
        RuleFor(x => x.TeacherId).NotEmpty();
        RuleFor(x => x.OrderedItemIds).NotEmpty();
        RuleFor(x => x.Version).NotEmpty();
    }
}

public class ReorderTrainingItemsCommandHandler : ICommandHandler<ReorderTrainingItemsCommand>
{
    private readonly ITrainingPackRepository _repository;
    private readonly ILogger<ReorderTrainingItemsCommandHandler> _logger;

    public ReorderTrainingItemsCommandHandler(ITrainingPackRepository repository, ILogger<ReorderTrainingItemsCommandHandler> logger)
    {
        _repository = repository;
        _logger = logger;
    }

    public async Task HandleAsync(ReorderTrainingItemsCommand command, CancellationToken cancellationToken = default)
    {
        _logger.LogInformation("Started ReorderTrainingItems for Pack {PackId}", command.PackId);

        var pack = await _repository.GetByIdAsync(command.PackId, cancellationToken);
        if (pack == null)
        {
            _logger.LogWarning("TrainingPack {PackId} not found.", command.PackId);
            throw new Exception($"TrainingPack {command.PackId} not found.");
        }

        if (pack.TeacherId != command.TeacherId)
        {
            _logger.LogWarning("Teacher {TeacherId} is not authorized to reorder items in Pack {PackId}.", command.TeacherId, command.PackId);
            throw new Exception("Unauthorized.");
        }
        
        if (pack.Version != command.Version)
        {
             _logger.LogWarning("Concurrency conflict detected for Pack {PackId}.", command.PackId);
             throw new Exception("Concurrency conflict.");
        }

        pack.ReorderTrainingItems(command.OrderedItemIds);

        await _repository.UpdateAsync(pack, cancellationToken);

        _logger.LogInformation("Completed ReorderTrainingItems successfully.");
    }
}
