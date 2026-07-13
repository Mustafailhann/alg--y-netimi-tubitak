using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using RealityLens.Domain.Entities;

namespace RealityLens.Persistence.Configurations;

public class GroundTruthConfiguration : IEntityTypeConfiguration<GroundTruth>
{
    public void Configure(EntityTypeBuilder<GroundTruth> builder)
    {
        builder.HasKey(x => x.Id);
        builder.Property(x => x.CreatedAt).IsRequired();
        builder.Property(x => x.UpdatedAt).IsRequired();

        builder.Property(x => x.Judgment).HasConversion<string>().IsRequired();
        builder.Property(x => x.Status).HasConversion<string>().IsRequired();
        builder.Property(x => x.Reason).IsRequired().HasMaxLength(1000);

        builder.HasOne(x => x.Assessment)
            .WithOne(a => a.GroundTruth)
            .HasForeignKey<GroundTruth>(x => x.AssessmentId)
            .OnDelete(DeleteBehavior.Cascade);

        builder.HasOne(x => x.ManipulationCategory)
            .WithMany()
            .HasForeignKey(x => x.ManipulationCategoryId)
            .OnDelete(DeleteBehavior.Restrict);
    }
}
