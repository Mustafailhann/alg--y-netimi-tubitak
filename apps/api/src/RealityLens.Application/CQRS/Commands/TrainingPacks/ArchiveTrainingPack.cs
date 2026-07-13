using System;
using System.Threading;
using System.Threading.Tasks;
using FluentValidation;
using RealityLens.Application.CQRS.Interfaces;
using RealityLens.Domain.Repositories;
using Microsoft.Extensions.Logging;

namespace RealityLens.Application.CQRS.Commands.TrainingPacks;

public record ArchiveTrainingPackCommand(Guid PackId, Guid TeacherId, Guid Version) : ICommand;

public class ArchiveTrainingPackCommandValidator : AbstractValidator<ArchiveTrainingPackCommand>
{
    public ArchiveTrainingPackCommandValidator()
    {
        RuleFor(x => x.PackId).NotEmpty();
        RuleFor(x => x.TeacherId).NotEmpty();
        RuleFor(x => x.Version).NotEmpty();
    }
}

public class ArchiveTrainingPackCommandHandler : ICommandHandler<ArchiveTrainingPackCommand>
{
    private readonly ITrainingPackRepository _repository;
    private readonly ILogger<ArchiveTrainingPackCommandHandler> _logger;

    public ArchiveTrainingPackCommandHandler(ITrainingPackRepository repository, ILogger<ArchiveTrainingPackCommandHandler> logger)
    {
        _repository = repository;
        _logger = logger;
    }

    public async Task HandleAsync(ArchiveTrainingPackCommand command, CancellationToken cancellationToken = default)
    {
        _logger.LogInformation("Started ArchiveTrainingPack for Pack {PackId}", command.PackId);

        var pack = await _repository.GetByIdAsync(command.PackId, cancellationToken);
        if (pack == null)
        {
            _logger.LogWarning("TrainingPack {PackId} not found.", command.PackId);
            throw new Exception($"TrainingPack {command.PackId} not found.");
        }

        if (pack.TeacherId != command.TeacherId)
        {
            _logger.LogWarning("Teacher {TeacherId} is not authorized to archive Pack {PackId}.", command.TeacherId, command.PackId);
            throw new Exception("Unauthorized.");
        }
        
        if (pack.Version != command.Version)
        {
             _logger.LogWarning("Concurrency conflict detected for Pack {PackId}.", command.PackId);
             throw new Exception("Concurrency conflict.");
        }

        pack.Archive(command.TeacherId);

        await _repository.UpdateAsync(pack, cancellationToken);

        _logger.LogInformation("Completed ArchiveTrainingPack successfully. PackId: {PackId}", pack.Id);
    }
}
