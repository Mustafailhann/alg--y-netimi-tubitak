using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using RealityLens.Domain.Entities;

namespace RealityLens.Persistence.Configurations;

public class AnnotationConfiguration : IEntityTypeConfiguration<Annotation>
{
    public void Configure(EntityTypeBuilder<Annotation> builder)
    {
        builder.HasKey(x => x.Id);
        builder.Property(x => x.CreatedAt).IsRequired();
        builder.Property(x => x.UpdatedAt).IsRequired();

        builder.Property(x => x.Type).HasConversion<string>().IsRequired();
        builder.Property(x => x.GeometryData).HasColumnType("jsonb").IsRequired();

        builder.Property(x => x.CreatedBy).IsRequired();

        builder.HasOne(x => x.GroundTruth)
            .WithMany(g => g.Annotations)
            .HasForeignKey(x => x.GroundTruthId)
            .OnDelete(DeleteBehavior.Cascade);

        builder.HasOne(x => x.ParticipantAnswer)
            .WithMany(p => p.Annotations)
            .HasForeignKey(x => x.ParticipantAnswerId)
            .OnDelete(DeleteBehavior.Cascade);

        builder.HasIndex(x => x.GroundTruthId);
        builder.HasIndex(x => x.ParticipantAnswerId);
    }
}
