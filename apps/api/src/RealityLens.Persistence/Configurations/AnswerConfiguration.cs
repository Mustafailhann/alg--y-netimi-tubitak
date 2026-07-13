using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using RealityLens.Domain.Entities;

namespace RealityLens.Persistence.Configurations;

public class AnswerConfiguration : IEntityTypeConfiguration<Answer>
{
    public void Configure(EntityTypeBuilder<Answer> builder)
    {
        builder.HasKey(x => x.Id);
        builder.Property(x => x.CreatedAt).IsRequired();
        builder.Property(x => x.UpdatedAt).IsRequired();

        builder.Property(x => x.Judgment).HasConversion<string>().IsRequired();
        builder.Property(x => x.Reason).IsRequired().HasMaxLength(1000);

        builder.HasOne(x => x.Session)
            .WithOne(s => s.Answer)
            .HasForeignKey<Answer>(x => x.SessionId)
            .OnDelete(DeleteBehavior.Cascade);

        builder.HasOne(x => x.ManipulationCategory)
            .WithMany()
            .HasForeignKey(x => x.ManipulationCategoryId)
            .OnDelete(DeleteBehavior.Restrict);
    }
}
