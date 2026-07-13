using System;
using System.Threading;
using System.Threading.Tasks;
using FluentValidation;
using RealityLens.Application.CQRS.Interfaces;
using RealityLens.Domain.Entities;
using RealityLens.Domain.Repositories;
using Microsoft.Extensions.Logging;

namespace RealityLens.Application.CQRS.Commands.TrainingPacks;

public record CreateTrainingPackCommand(Guid TeacherId, string Title, int? EstimatedDuration) : ICommand<Guid>;

public class CreateTrainingPackCommandValidator : AbstractValidator<CreateTrainingPackCommand>
{
    public CreateTrainingPackCommandValidator()
    {
        RuleFor(x => x.TeacherId).NotEmpty();
        RuleFor(x => x.Title).NotEmpty().MaximumLength(200);
    }
}

public class CreateTrainingPackCommandHandler : ICommandHandler<CreateTrainingPackCommand, Guid>
{
    private readonly ITrainingPackRepository _repository;
    private readonly ILogger<CreateTrainingPackCommandHandler> _logger;

    public CreateTrainingPackCommandHandler(ITrainingPackRepository repository, ILogger<CreateTrainingPackCommandHandler> logger)
    {
        _repository = repository;
        _logger = logger;
    }

    public async Task<Guid> HandleAsync(CreateTrainingPackCommand command, CancellationToken cancellationToken = default)
    {
        _logger.LogInformation("Started CreateTrainingPack for Teacher {TeacherId} with Title {Title}", command.TeacherId, command.Title);

        var pack = new TrainingPack(command.TeacherId, command.Title, command.EstimatedDuration);
        
        await _repository.AddAsync(pack, cancellationToken);

        _logger.LogInformation("Completed CreateTrainingPack successfully. PackId: {PackId}", pack.Id);
        
        return pack.Id;
    }
}
