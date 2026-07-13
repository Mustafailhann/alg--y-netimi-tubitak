using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using RealityLens.Domain.Entities;

namespace RealityLens.Persistence.Configurations;

public class TrainingSessionConfiguration : IEntityTypeConfiguration<TrainingSession>
{
    public void Configure(EntityTypeBuilder<TrainingSession> builder)
    {
        builder.HasKey(x => x.Id);
        
        builder.Property(x => x.Version).IsConcurrencyToken();
        builder.HasQueryFilter(x => !x.IsDeleted);

        builder.OwnsOne(x => x.JoinCode, jc =>
        {
            jc.Property(j => j.Value)
                .HasColumnName("JoinCode")
                .HasMaxLength(6)
                .IsRequired();
            
            jc.HasIndex(j => j.Value).IsUnique(); // Unique join code index
        });

        builder.OwnsOne(x => x.Configuration, conf =>
        {
            conf.ToJson();
        });

        builder.Property(x => x.Status)
            .HasConversion<string>()
            .IsRequired();

        builder.HasMany(x => x.Participants)
            .WithOne(x => x.TrainingSession)
            .HasForeignKey(x => x.TrainingSessionId)
            .OnDelete(DeleteBehavior.Cascade);
    }
}
