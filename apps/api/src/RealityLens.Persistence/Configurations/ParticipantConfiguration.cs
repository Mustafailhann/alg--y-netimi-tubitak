using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using RealityLens.Domain.Entities;

namespace RealityLens.Persistence.Configurations;

public class ParticipantConfiguration : IEntityTypeConfiguration<Participant>
{
    public void Configure(EntityTypeBuilder<Participant> builder)
    {
        builder.HasKey(x => x.Id);
        builder.Property(x => x.Id).ValueGeneratedNever();
        
        builder.Property(x => x.Version).IsConcurrencyToken();
        builder.HasQueryFilter(x => !x.IsDeleted);

        builder.Property(x => x.StudentIdentifier)
            .IsRequired()
            .HasMaxLength(255);

        builder.Property(x => x.ConnectionStatus)
            .HasConversion<string>()
            .IsRequired();
            
        // Additional indexes could be added if needed, e.g. for session + student combo
    }
}
