using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using RealityLens.Domain.Entities;

namespace RealityLens.Persistence.Configurations;

public class TrainingItemConfiguration : IEntityTypeConfiguration<TrainingItem>
{
    public void Configure(EntityTypeBuilder<TrainingItem> builder)
    {
        builder.HasKey(x => x.Id);
        
        builder.Property(x => x.Version).IsConcurrencyToken();
        builder.HasQueryFilter(x => !x.IsDeleted);

        builder.Property(x => x.OrderIndex)
            .IsRequired();

        builder.HasOne(x => x.Assessment)
            .WithMany()
            .HasForeignKey(x => x.AssessmentId)
            .OnDelete(DeleteBehavior.Restrict);
    }
}
