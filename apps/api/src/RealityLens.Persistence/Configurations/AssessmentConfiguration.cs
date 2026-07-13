using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using RealityLens.Domain.Entities;

namespace RealityLens.Persistence.Configurations;

public class AssessmentConfiguration : IEntityTypeConfiguration<Assessment>
{
    public void Configure(EntityTypeBuilder<Assessment> builder)
    {
        builder.HasKey(x => x.Id);
        builder.Property(x => x.CreatedAt).IsRequired();
        builder.Property(x => x.UpdatedAt).IsRequired();

        builder.Property(x => x.Question).IsRequired().HasMaxLength(500);
        builder.Property(x => x.Status).HasConversion<string>().IsRequired();

        builder.HasOne(x => x.Media)
            .WithMany(m => m.Assessments)
            .HasForeignKey(x => x.MediaId)
            .OnDelete(DeleteBehavior.Restrict);
    }
}
