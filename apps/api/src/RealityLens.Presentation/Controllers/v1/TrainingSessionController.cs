using Asp.Versioning;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using RealityLens.Application.CQRS.Commands.TrainingSessions;
using RealityLens.Application.CQRS.Interfaces;
using RealityLens.Application.CQRS.Queries.TrainingSessions;
using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace RealityLens.Presentation.Controllers.v1;

[ApiController]
[ApiVersion("1.0")]
[Route("api/v{version:apiVersion}/training-sessions")]
public class TrainingSessionController : ControllerBase
{
    private readonly ICommandDispatcher _commandDispatcher;
    private readonly IQueryDispatcher _queryDispatcher;

    public TrainingSessionController(ICommandDispatcher commandDispatcher, IQueryDispatcher queryDispatcher)
    {
        _commandDispatcher = commandDispatcher;
        _queryDispatcher = queryDispatcher;
    }

    [HttpGet]
    public async Task<ActionResult<IEnumerable<TrainingSessionDto>>> GetMySessions(
        [FromQuery] Guid teacherId, // In real app, from claims
        CancellationToken cancellationToken)
    {
        var query = new GetTrainingSessionsByTeacherQuery(teacherId);
        var result = await _queryDispatcher.DispatchAsync<GetTrainingSessionsByTeacherQuery, IEnumerable<TrainingSessionDto>>(query, cancellationToken);
        return Ok(result);
    }

    [HttpGet("{id:guid}")]
    public async Task<ActionResult<TrainingSessionDetailDto>> GetById(
        Guid id,
        [FromQuery] Guid teacherId, // In real app, from claims
        CancellationToken cancellationToken)
    {
        var query = new GetTrainingSessionByIdQuery(id, teacherId);
        var result = await _queryDispatcher.DispatchAsync<GetTrainingSessionByIdQuery, TrainingSessionDetailDto?>(query, cancellationToken);
        
        if (result == null)
            return NotFound();
            
        return Ok(result);
    }

    [HttpGet("{id:guid}/participants")]
    public async Task<ActionResult<IEnumerable<ParticipantDto>>> GetParticipants(
        Guid id,
        [FromQuery] Guid teacherId, // In real app, from claims
        CancellationToken cancellationToken)
    {
        var query = new GetTrainingSessionParticipantsQuery(id, teacherId);
        var result = await _queryDispatcher.DispatchAsync<GetTrainingSessionParticipantsQuery, IEnumerable<ParticipantDto>>(query, cancellationToken);
        return Ok(result);
    }

    [HttpPost]
    public async Task<ActionResult> Create(
        [FromBody] CreateTrainingSessionRequest request,
        CancellationToken cancellationToken)
    {
        var command = new CreateTrainingSessionCommand(
            request.TrainingPackId, 
            request.TeacherId, 
            request.Configuration.TimeLimitMinutes,
            request.Configuration.RandomQuestionOrder,
            request.Configuration.AllowRetry,
            request.Configuration.ShowImmediateFeedback,
            request.Configuration.LeaderboardEnabled,
            request.Configuration.CanvasRequired,
            request.Configuration.MaximumAttempts,
            request.Configuration.AutoAdvance);
        var sessionId = await _commandDispatcher.DispatchAsync<CreateTrainingSessionCommand, Guid>(command, cancellationToken);
        return CreatedAtAction(nameof(GetById), new { id = sessionId, teacherId = request.TeacherId }, new { id = sessionId });
    }

    [HttpPost("{id:guid}/start")]
    public async Task<ActionResult> Start(
        Guid id,
        [FromBody] StartTrainingSessionRequest request,
        CancellationToken cancellationToken)
    {
        var command = new StartTrainingSessionCommand(id, request.TeacherId, request.Version);
        await _commandDispatcher.DispatchAsync(command, cancellationToken);
        return NoContent();
    }

    [HttpPost("{id:guid}/complete")]
    public async Task<ActionResult> Complete(
        Guid id,
        [FromBody] CompleteTrainingSessionRequest request,
        CancellationToken cancellationToken)
    {
        var command = new CompleteTrainingSessionCommand(id, request.TeacherId, request.Version);
        await _commandDispatcher.DispatchAsync(command, cancellationToken);
        return NoContent();
    }

    [HttpPost("{id:guid}/cancel")]
    public async Task<ActionResult> Cancel(
        Guid id,
        [FromBody] CancelTrainingSessionRequest request,
        CancellationToken cancellationToken)
    {
        var command = new CancelTrainingSessionCommand(id, request.TeacherId, request.Version);
        await _commandDispatcher.DispatchAsync(command, cancellationToken);
        return NoContent();
    }

    [HttpPost("participants")]
    public async Task<ActionResult> AddParticipant(
        [FromBody] AddParticipantRequest request,
        CancellationToken cancellationToken)
    {
        var command = new AddParticipantCommand(request.JoinCode, request.StudentIdentifier);
        var response = await _commandDispatcher.DispatchAsync<AddParticipantCommand, AddParticipantResponse>(command, cancellationToken);
        return Ok(new { id = response.ParticipantId, token = response.Token });
    }
    [HttpPost("{id:guid}/next-question")]
    public async Task<ActionResult> NextQuestion(
        Guid id,
        [FromBody] NextQuestionRequest request,
        CancellationToken cancellationToken)
    {
        var command = new NextQuestionCommand(id, request.TeacherId);
        await _commandDispatcher.DispatchAsync(command, cancellationToken);
        return NoContent();
    }

    [HttpPost("{id:guid}/finish")]
    public async Task<ActionResult> Finish(
        Guid id,
        [FromBody] FinishSessionRequest request,
        CancellationToken cancellationToken)
    {
        var command = new FinishSessionCommand(id, request.TeacherId);
        await _commandDispatcher.DispatchAsync(command, cancellationToken);
        return NoContent();
    }

    [HttpGet("{id:guid}/student-state")]
    public async Task<ActionResult<StudentSessionStateDto>> GetStudentState(
        Guid id,
        [FromQuery] Guid participantId,
        CancellationToken cancellationToken)
    {
        var query = new GetStudentSessionStateQuery(id, participantId);
        var result = await _queryDispatcher.DispatchAsync<GetStudentSessionStateQuery, StudentSessionStateDto?>(query, cancellationToken);
        
        if (result == null)
            return NotFound();
            
        return Ok(result);
    }

    [HttpGet("{id:guid}/current-question")]
    public async Task<ActionResult<StudentQuestionDto>> GetCurrentQuestion(
        Guid id,
        CancellationToken cancellationToken)
    {
        var query = new GetCurrentQuestionQuery(id);
        var result = await _queryDispatcher.DispatchAsync<GetCurrentQuestionQuery, StudentQuestionDto?>(query, cancellationToken);
        
        if (result == null)
            return NotFound();
            
        return Ok(result);
    }

    [HttpPost("{id:guid}/answers")]
    public async Task<ActionResult> SubmitAnswer(
        Guid id,
        [FromBody] SubmitAnswerRequest request,
        CancellationToken cancellationToken)
    {
        var command = new SubmitAnswerCommand(id, request.ParticipantId, request.Judgment, request.TimeTakenMilliseconds, request.AnnotationIds);
        var answerId = await _commandDispatcher.DispatchAsync<SubmitAnswerCommand, Guid>(command, cancellationToken);
        return Ok(new { id = answerId });
    }

    [HttpPost("{id:guid}/leave")]
    public async Task<ActionResult> LeaveSession(
        Guid id,
        [FromBody] LeaveSessionRequest request,
        CancellationToken cancellationToken)
    {
        var command = new LeaveSessionCommand(id, request.ParticipantId);
        await _commandDispatcher.DispatchAsync(command, cancellationToken);
        return NoContent();
    }

    [HttpPost("{id:guid}/heartbeat")]
    public async Task<ActionResult> Heartbeat(
        Guid id,
        [FromBody] ParticipantHeartbeatRequest request,
        CancellationToken cancellationToken)
    {
        var command = new ParticipantHeartbeatCommand(id, request.ParticipantId);
        await _commandDispatcher.DispatchAsync(command, cancellationToken);
        return NoContent();
    }

    [HttpGet("{id:guid}/results")]
    public async Task<ActionResult<StudentSessionResultDto>> GetResults(
        Guid id,
        [FromQuery] Guid participantId,
        CancellationToken cancellationToken)
    {
        var query = new GetSessionResultsQuery(id, participantId);
        var result = await _queryDispatcher.DispatchAsync<GetSessionResultsQuery, StudentSessionResultDto?>(query, cancellationToken);
        
        if (result == null)
            return NotFound();
            
        return Ok(result);
    }

    [HttpGet("{id:guid}/question-history")]
    [Authorize(Roles = "Participant")]
    public async Task<ActionResult<IEnumerable<QuestionHistoryDto>>> GetQuestionHistory(
        Guid id,
        CancellationToken cancellationToken)
    {
        var participantId = Guid.Parse(User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)!.Value);
        var query = new GetQuestionHistoryQuery(id, participantId);
        var result = await _queryDispatcher.DispatchAsync<GetQuestionHistoryQuery, List<QuestionHistoryDto>>(query, cancellationToken);
        return Ok(result);
    }

    [HttpGet("{id:guid}/question-history/{trainingItemId:guid}/review")]
    [Authorize(Roles = "Participant")]
    public async Task<ActionResult<QuestionReviewDto>> GetQuestionReview(
        Guid id,
        Guid trainingItemId,
        CancellationToken cancellationToken)
    {
        var participantId = Guid.Parse(User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)!.Value);
        var query = new GetQuestionReviewQuery(id, participantId, trainingItemId);
        var result = await _queryDispatcher.DispatchAsync<GetQuestionReviewQuery, QuestionReviewDto?>(query, cancellationToken);
        if (result == null) return NotFound();
        return Ok(result);
    }
}

// Request DTOs
public record SessionConfigurationDto(
    int? TimeLimitMinutes, 
    bool RandomQuestionOrder, 
    bool AllowRetry, 
    bool ShowImmediateFeedback, 
    bool LeaderboardEnabled, 
    bool CanvasRequired, 
    int? MaximumAttempts,
    bool AutoAdvance);

public record CreateTrainingSessionRequest(Guid TrainingPackId, Guid TeacherId, SessionConfigurationDto Configuration);
public record StartTrainingSessionRequest(Guid TeacherId, Guid Version);
public record CompleteTrainingSessionRequest(Guid TeacherId, Guid Version);
public record CancelTrainingSessionRequest(Guid TeacherId, Guid Version);
public record AddParticipantRequest(string JoinCode, string StudentIdentifier);
public record NextQuestionRequest(Guid TeacherId);
public record FinishSessionRequest(Guid TeacherId);
public record SubmitAnswerRequest(Guid ParticipantId, RealityLens.Domain.Enums.Judgment Judgment, long TimeTakenMilliseconds, List<Guid>? AnnotationIds = null);
public record LeaveSessionRequest(Guid ParticipantId);
public record ParticipantHeartbeatRequest(Guid ParticipantId);
