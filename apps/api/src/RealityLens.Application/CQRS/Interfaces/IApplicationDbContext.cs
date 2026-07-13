using System.Threading;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using RealityLens.Domain.Entities;

namespace RealityLens.Application.CQRS.Interfaces;

public interface IApplicationDbContext
{
    DbSet<TrainingPack> TrainingPacks { get; }
    DbSet<TrainingItem> TrainingItems { get; }
    DbSet<TrainingSession> TrainingSessions { get; }
    DbSet<Participant> Participants { get; }
    DbSet<ParticipantAnswer> ParticipantAnswers { get; }
    DbSet<Assessment> Assessments { get; }
    DbSet<Media> Media { get; }
    DbSet<Annotation> Annotations { get; }

    Task<int> SaveChangesAsync(CancellationToken cancellationToken);
}
