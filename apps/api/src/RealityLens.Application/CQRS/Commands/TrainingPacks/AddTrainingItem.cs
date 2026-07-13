using System;
using System.Threading;
using System.Threading.Tasks;
using FluentValidation;
using RealityLens.Application.CQRS.Interfaces;
using RealityLens.Domain.Entities;
using RealityLens.Domain.Repositories;
using Microsoft.Extensions.Logging;

namespace RealityLens.Application.CQRS.Commands.TrainingPacks;

public record AddTrainingItemCommand(Guid PackId, Guid TeacherId, Guid AssessmentId, int OrderIndex, Guid Version) : ICommand<Guid>;

public class AddTrainingItemCommandValidator : AbstractValidator<AddTrainingItemCommand>
{
    public AddTrainingItemCommandValidator()
    {
        RuleFor(x => x.PackId).NotEmpty();
        RuleFor(x => x.TeacherId).NotEmpty();
        RuleFor(x => x.AssessmentId).NotEmpty();
        RuleFor(x => x.OrderIndex).GreaterThanOrEqualTo(0);
        RuleFor(x => x.Version).NotEmpty();
    }
}

public class AddTrainingItemCommandHandler : ICommandHandler<AddTrainingItemCommand, Guid>
{
    private readonly ITrainingPackRepository _repository;
    private readonly ILogger<AddTrainingItemCommandHandler> _logger;

    public AddTrainingItemCommandHandler(ITrainingPackRepository repository, ILogger<AddTrainingItemCommandHandler> logger)
    {
        _repository = repository;
        _logger = logger;
    }

    public async Task<Guid> HandleAsync(AddTrainingItemCommand command, CancellationToken cancellationToken = default)
    {
        _logger.LogInformation("Started AddTrainingItem for Pack {PackId}", command.PackId);

        var pack = await _repository.GetByIdAsync(command.PackId, cancellationToken);
        if (pack == null)
        {
            _logger.LogWarning("TrainingPack {PackId} not found.", command.PackId);
            throw new Exception($"TrainingPack {command.PackId} not found.");
        }

        if (pack.TeacherId != command.TeacherId)
        {
            _logger.LogWarning("Teacher {TeacherId} is not authorized to add item to Pack {PackId}.", command.TeacherId, command.PackId);
            throw new Exception("Unauthorized.");
        }
        
        if (pack.Version != command.Version)
        {
             _logger.LogWarning("Concurrency conflict detected for Pack {PackId}.", command.PackId);
             throw new Exception("Concurrency conflict.");
        }

        var item = new TrainingItem(command.PackId, command.AssessmentId, command.OrderIndex);
        pack.AddTrainingItem(item);

        await _repository.AddTrainingItemAsync(item, cancellationToken);
        await _repository.UpdateAsync(pack, cancellationToken);

        _logger.LogInformation("Completed AddTrainingItem successfully. ItemId: {ItemId}", item.Id);
        return item.Id;
    }
}
