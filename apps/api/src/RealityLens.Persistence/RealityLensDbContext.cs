using Microsoft.EntityFrameworkCore;
using RealityLens.Domain.Entities;
using RealityLens.Persistence.Extensions;
using System.Reflection;

using RealityLens.Application.CQRS.Interfaces;

namespace RealityLens.Persistence;

public class RealityLensDbContext : DbContext, IApplicationDbContext
{
    public RealityLensDbContext(DbContextOptions<RealityLensDbContext> options) : base(options)
    {
    }

    public DbSet<User> Users => Set<User>();
    public DbSet<Role> Roles => Set<Role>();
    [Obsolete("Deprecated in favor of Sprint 6 Training Domain entities. Scheduled for removal in a future cleanup sprint.")]
    public DbSet<Class> Classes => Set<Class>();
    
    [Obsolete("Deprecated in favor of Sprint 6 Training Domain entities. Scheduled for removal in a future cleanup sprint.")]
    public DbSet<Enrollment> Enrollments => Set<Enrollment>();
    
    public DbSet<Assessment> Assessments => Set<Assessment>();
    
    [Obsolete("Deprecated in favor of Sprint 6 Training Domain entities. Scheduled for removal in a future cleanup sprint.")]
    public DbSet<Assignment> Assignments => Set<Assignment>();
    
    public DbSet<Media> Media => Set<Media>();
    public DbSet<AIAnalysis> AIAnalyses => Set<AIAnalysis>();
    public DbSet<GroundTruth> GroundTruths => Set<GroundTruth>();
    public DbSet<ManipulationCategory> ManipulationCategories => Set<ManipulationCategory>();
    
    [Obsolete("Deprecated in favor of Sprint 6 Training Domain entities. Scheduled for removal in a future cleanup sprint.")]
    public DbSet<Session> Sessions => Set<Session>();
    
    public DbSet<Answer> Answers => Set<Answer>();
    public DbSet<Annotation> Annotations => Set<Annotation>();
    
    [Obsolete("Deprecated in favor of Sprint 6 Training Domain entities. Scheduled for removal in a future cleanup sprint.")]
    public DbSet<Evaluation> Evaluations => Set<Evaluation>();
    
    public DbSet<RefreshToken> RefreshTokens => Set<RefreshToken>();

    // Sprint 6 Training Domain Entities
    public DbSet<TrainingPack> TrainingPacks => Set<TrainingPack>();
    public DbSet<TrainingItem> TrainingItems => Set<TrainingItem>();
    public DbSet<TrainingSession> TrainingSessions => Set<TrainingSession>();
    public DbSet<Participant> Participants => Set<Participant>();
    public DbSet<ParticipantAnswer> ParticipantAnswers => Set<ParticipantAnswer>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);
        
        modelBuilder.ApplyConfigurationsFromAssembly(Assembly.GetExecutingAssembly());
        
        modelBuilder.SeedData();
    }
}
