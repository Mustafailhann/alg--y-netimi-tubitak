using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using RealityLens.Domain.Entities;

namespace RealityLens.Persistence.Configurations;

public class AssignmentConfiguration : IEntityTypeConfiguration<Assignment>
{
    public void Configure(EntityTypeBuilder<Assignment> builder)
    {
        builder.HasKey(x => x.Id);
        builder.Property(x => x.CreatedAt).IsRequired();
        builder.Property(x => x.UpdatedAt).IsRequired();

        builder.Property(x => x.TargetType).HasConversion<string>().IsRequired();

        builder.HasIndex(x => new { x.AssessmentId, x.TargetType, x.TargetId }).IsUnique();

        builder.HasOne(x => x.Assessment)
            .WithMany(a => a.Assignments)
            .HasForeignKey(x => x.AssessmentId)
            .OnDelete(DeleteBehavior.Restrict);

        builder.HasOne(x => x.AssignedByTeacher)
            .WithMany()
            .HasForeignKey(x => x.AssignedByTeacherId)
            .OnDelete(DeleteBehavior.Restrict);
    }
}
