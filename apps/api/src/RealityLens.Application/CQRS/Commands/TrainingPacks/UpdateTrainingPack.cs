using System;
using System.Threading;
using System.Threading.Tasks;
using FluentValidation;
using RealityLens.Application.CQRS.Interfaces;
using RealityLens.Domain.Repositories;
using Microsoft.Extensions.Logging;

namespace RealityLens.Application.CQRS.Commands.TrainingPacks;

public record UpdateTrainingPackCommand(Guid PackId, Guid TeacherId, string Title, int? EstimatedDuration, Guid Version) : ICommand;

public class UpdateTrainingPackCommandValidator : AbstractValidator<UpdateTrainingPackCommand>
{
    public UpdateTrainingPackCommandValidator()
    {
        RuleFor(x => x.PackId).NotEmpty();
        RuleFor(x => x.TeacherId).NotEmpty();
        RuleFor(x => x.Title).NotEmpty().MaximumLength(200);
        RuleFor(x => x.Version).NotEmpty();
    }
}

public class UpdateTrainingPackCommandHandler : ICommandHandler<UpdateTrainingPackCommand>
{
    private readonly ITrainingPackRepository _repository;
    private readonly ILogger<UpdateTrainingPackCommandHandler> _logger;

    public UpdateTrainingPackCommandHandler(ITrainingPackRepository repository, ILogger<UpdateTrainingPackCommandHandler> logger)
    {
        _repository = repository;
        _logger = logger;
    }

    public async Task HandleAsync(UpdateTrainingPackCommand command, CancellationToken cancellationToken = default)
    {
        _logger.LogInformation("Started UpdateTrainingPack for Pack {PackId}", command.PackId);

        var pack = await _repository.GetByIdAsync(command.PackId, cancellationToken);
        if (pack == null)
        {
            _logger.LogWarning("TrainingPack {PackId} not found.", command.PackId);
            throw new Exception($"TrainingPack {command.PackId} not found."); // In a real app we use custom exceptions
        }

        if (pack.TeacherId != command.TeacherId)
        {
            _logger.LogWarning("Teacher {TeacherId} is not authorized to update Pack {PackId}.", command.TeacherId, command.PackId);
            throw new Exception("Unauthorized.");
        }
        
        // Concurrency handled by EF Core matching Version during SaveChanges
        if (pack.Version != command.Version)
        {
             _logger.LogWarning("Concurrency conflict detected for Pack {PackId}.", command.PackId);
             throw new Exception("Concurrency conflict.");
        }

        pack.Update(command.Title, command.EstimatedDuration);

        await _repository.UpdateAsync(pack, cancellationToken);

        _logger.LogInformation("Completed UpdateTrainingPack successfully. PackId: {PackId}", pack.Id);
    }
}
