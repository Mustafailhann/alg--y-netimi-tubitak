using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using RealityLens.Domain.Entities;

namespace RealityLens.Persistence.Configurations;

public class ParticipantAnswerConfiguration : IEntityTypeConfiguration<ParticipantAnswer>
{
    public void Configure(EntityTypeBuilder<ParticipantAnswer> builder)
    {
        builder.ToTable("ParticipantAnswers");

        builder.HasKey(x => x.Id);

        builder.Property(x => x.Judgment)
            .HasConversion<string>()
            .IsRequired();

        // Index for querying by session
        builder.HasIndex(x => x.TrainingSessionId);
        
        // Index for querying by participant in a session
        builder.HasIndex(x => new { x.TrainingSessionId, x.ParticipantId });

        // Index for checking if participant already answered a specific question
        builder.HasIndex(x => new { x.ParticipantId, x.TrainingItemId }).IsUnique();
        
    }
}
