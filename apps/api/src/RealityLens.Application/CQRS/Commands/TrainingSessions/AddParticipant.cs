using System;
using System.Threading;
using System.Threading.Tasks;
using FluentValidation;
using RealityLens.Application.CQRS.Interfaces;
using RealityLens.Domain.Entities;
using RealityLens.Domain.Repositories;
using RealityLens.Domain.ValueObjects;
using Microsoft.Extensions.Logging;

using RealityLens.Application.Interfaces;

namespace RealityLens.Application.CQRS.Commands.TrainingSessions;

public record AddParticipantResponse(Guid ParticipantId, string Token);

public record AddParticipantCommand(string JoinCode, string StudentIdentifier) : ICommand<AddParticipantResponse>;

public class AddParticipantCommandValidator : AbstractValidator<AddParticipantCommand>
{
    public AddParticipantCommandValidator()
    {
        RuleFor(x => x.JoinCode).NotEmpty().Length(6);
        RuleFor(x => x.StudentIdentifier).NotEmpty().MaximumLength(200);
    }
}

public class AddParticipantCommandHandler : ICommandHandler<AddParticipantCommand, AddParticipantResponse>
{
    private readonly ITrainingSessionRepository _repository;
    private readonly ITokenService _tokenService;
    private readonly ILogger<AddParticipantCommandHandler> _logger;

    public AddParticipantCommandHandler(ITrainingSessionRepository repository, ITokenService tokenService, ILogger<AddParticipantCommandHandler> logger)
    {
        _repository = repository;
        _tokenService = tokenService;
        _logger = logger;
    }

    public async Task<AddParticipantResponse> HandleAsync(AddParticipantCommand command, CancellationToken cancellationToken = default)
    {
        _logger.LogInformation("Started AddParticipant for JoinCode {JoinCode}", command.JoinCode);

        // We need to look up the session by join code.
        var session = await _repository.GetByJoinCodeAsync(new JoinCode(command.JoinCode), cancellationToken);
        if (session == null)
            throw new System.Collections.Generic.KeyNotFoundException($"TrainingSession with JoinCode {command.JoinCode} not found.");

        // Check if participant already exists with this identifier
        var existingParticipant = session.Participants.FirstOrDefault(p => p.StudentIdentifier == command.StudentIdentifier);
        
        Guid participantId;
        if (existingParticipant != null)
        {
            participantId = existingParticipant.Id;
            _logger.LogInformation("Participant {ParticipantId} already exists in session. Rejoining.", participantId);
            
            existingParticipant.UpdateConnectionStatus(RealityLens.Domain.Enums.ConnectionStatus.Online);
            await _repository.UpdateAsync(session, cancellationToken);
        }
        else
        {
            var participant = new Participant(session.Id, command.StudentIdentifier);
            session.AddParticipant(participant);
            await _repository.UpdateAsync(session, cancellationToken);
            participantId = participant.Id;
            _logger.LogInformation("Completed AddParticipant successfully. ParticipantId: {ParticipantId}", participantId);
        }
        
        var token = _tokenService.GenerateParticipantToken(participantId, session.Id);

        return new AddParticipantResponse(participantId, token);
    }
}
