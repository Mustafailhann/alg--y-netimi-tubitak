using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using RealityLens.Domain.Entities;

namespace RealityLens.Persistence.Configurations;

public class TrainingPackConfiguration : IEntityTypeConfiguration<TrainingPack>
{
    public void Configure(EntityTypeBuilder<TrainingPack> builder)
    {
        builder.HasKey(x => x.Id);
        
        builder.Property(x => x.Version).IsConcurrencyToken();
        builder.HasQueryFilter(x => !x.IsDeleted);

        builder.Property(x => x.TeacherId)
            .IsRequired();

        builder.Property(x => x.Title)
            .IsRequired()
            .HasMaxLength(255);

        builder.Property(x => x.Status)
            .HasConversion<string>()
            .IsRequired();
            
        builder.Property(x => x.EstimatedDuration);

        builder.HasMany(x => x.TrainingItems)
            .WithOne(x => x.TrainingPack)
            .HasForeignKey(x => x.TrainingPackId)
            .OnDelete(DeleteBehavior.Cascade);

        builder.HasMany(x => x.TrainingSessions)
            .WithOne(x => x.TrainingPack)
            .HasForeignKey(x => x.TrainingPackId)
            .OnDelete(DeleteBehavior.Restrict); // Don't delete packs if they have sessions
    }
}
