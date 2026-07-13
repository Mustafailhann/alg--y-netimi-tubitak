using Microsoft.EntityFrameworkCore;
using RealityLens.Application.Interfaces;
using RealityLens.Domain.Entities;
using RealityLens.Domain.Enums;
using RealityLens.Application.CQRS.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace RealityLens.Application.CQRS.Commands.TrainingSessions;

public record SubmitAnswerCommand(
    Guid TrainingSessionId,
    Guid ParticipantId,
    Judgment Judgment,
    long TimeTakenMilliseconds,
    List<Guid>? AnnotationIds) : ICommand<Guid>;

public class SubmitAnswerCommandHandler : ICommandHandler<SubmitAnswerCommand, Guid>
{
    private readonly IApplicationDbContext _context;
    private readonly IScoringService _scoringService;

    public SubmitAnswerCommandHandler(IApplicationDbContext context, IScoringService scoringService)
    {
        _context = context;
        _scoringService = scoringService;
    }

    public async Task<Guid> HandleAsync(SubmitAnswerCommand request, CancellationToken cancellationToken)
    {
        var session = await _context.TrainingSessions
            .Include(x => x.Participants)
            .FirstOrDefaultAsync(x => x.Id == request.TrainingSessionId, cancellationToken);

        if (session == null)
            throw new Exception("Training Session not found");

        if (session.Status != TrainingSessionStatus.Active)
            throw new Exception("Session is not active.");

        var participant = session.Participants.FirstOrDefault(p => p.Id == request.ParticipantId);
        if (participant == null)
            throw new Exception("Participant not found in this session.");

        var packItems = await _context.TrainingItems
            .Where(ti => ti.TrainingPackId == session.TrainingPackId)
            .OrderBy(ti => ti.OrderIndex)
            .ToListAsync(cancellationToken);

        if (session.CurrentQuestionIndex >= packItems.Count)
            throw new Exception("No current question available.");

        var currentItem = packItems[session.CurrentQuestionIndex];

        var alreadyAnswered = await _context.ParticipantAnswers
            .AnyAsync(a => a.ParticipantId == request.ParticipantId && a.TrainingItemId == currentItem.Id, cancellationToken);

        if (alreadyAnswered)
            throw new Exception("Participant already answered this question.");

        bool isCorrect = false;

        var assessment = await _context.Assessments
            .Include(a => a.GroundTruth)
            .ThenInclude(g => g!.Annotations)
            .FirstOrDefaultAsync(a => a.Id == currentItem.AssessmentId, cancellationToken);

        var answer = new ParticipantAnswer(
            request.TrainingSessionId,
            request.ParticipantId,
            currentItem.Id,
            currentItem.AssessmentId,
            request.Judgment,
            isCorrect,
            request.TimeTakenMilliseconds);

        _context.ParticipantAnswers.Add(answer);

        // Link annotations
        if (request.AnnotationIds != null && request.AnnotationIds.Any())
        {
            var annotations = await _context.Annotations
                .Where(a => request.AnnotationIds.Contains(a.Id))
                .ToListAsync(cancellationToken);

            foreach (var ann in annotations)
            {
                ann.LinkToParticipantAnswer(answer.Id);
            }
        }

        var pack = await _context.TrainingPacks.FindAsync(session.TrainingPackId);

        if (assessment?.GroundTruth != null && pack != null)
        {
            try
            {
                List<object> teacherAnnotationList = new();
                var actualTeacherAnnotations = assessment.GroundTruth.Annotations.Where(a => a.ParticipantAnswerId == null).ToList();
                if (actualTeacherAnnotations.Any())
                {
                    foreach (var teacherAnn in actualTeacherAnnotations)
                    {
                        teacherAnnotationList.Add(new {
                            Type = teacherAnn.Type.ToString(),
                            Geometry = System.Text.Json.JsonDocument.Parse(teacherAnn.GeometryData).RootElement
                        });
                    }
                }

                var snapshotObj = new
                {
                    Judgment = assessment.GroundTruth.Judgment.ToString(),
                    ManipulationCategoryId = assessment.GroundTruth.ManipulationCategoryId,
                    Reason = assessment.GroundTruth.Reason,
                    Annotations = teacherAnnotationList
                };
                
                string groundTruthSnapshot = System.Text.Json.JsonSerializer.Serialize(snapshotObj);
                
                List<object> studentAnnotationList = new();
                if (request.AnnotationIds != null && request.AnnotationIds.Any())
                {
                    var studentAnnotations = await _context.Annotations
                        .Where(a => request.AnnotationIds.Contains(a.Id))
                        .ToListAsync(cancellationToken);

                    foreach (var studentAnn in studentAnnotations)
                    {
                        studentAnnotationList.Add(new {
                            Type = studentAnn.Type.ToString(),
                            Geometry = System.Text.Json.JsonDocument.Parse(studentAnn.GeometryData).RootElement
                        });
                    }
                }
                string studentSnapshot = System.Text.Json.JsonSerializer.Serialize(studentAnnotationList);

                var scoringResult = _scoringService.ScoreAnswer(
                    assessment.GroundTruth.Judgment,
                    groundTruthSnapshot,
                    request.Judgment,
                    studentSnapshot); 

                answer.UpdateScoring(
                    scoringResult.ClassificationScore,
                    scoringResult.LocalizationScore,
                    scoringResult.TotalScore,
                    scoringResult.IsCorrect);
            }
            catch
            {
                // Evaluation engine failed, fallback to basic scoring
                isCorrect = request.Judgment == assessment.GroundTruth.Judgment;
                answer.UpdateScoring(isCorrect ? 100 : 0, 0, isCorrect ? 50 : 0, isCorrect);
            }
        }
        else
        {
            // Fallback basic logic if no ground truth defined
            answer.UpdateScoring(100, 100, 100, true);
        }

        var totalQuestions = packItems.Count;
        var answeredQuestions = session.CurrentQuestionIndex + 1;
        var progress = (int)((double)answeredQuestions / totalQuestions * 100);

        // Calculate average score including the new answer
        var previousAnswers = await _context.ParticipantAnswers
            .Where(a => a.ParticipantId == request.ParticipantId && a.TrainingSessionId == request.TrainingSessionId)
            .ToListAsync(cancellationToken);
        
        var allScores = previousAnswers.Select(a => a.TotalScore ?? 0m).ToList();
        allScores.Add(answer.TotalScore ?? 0m);
        var newScore = (int)allScores.Average();

        participant.UpdateProgress(progress, newScore);

        await _context.SaveChangesAsync(cancellationToken);

        return answer.Id;
    }
}
