using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using RealityLens.Domain.Entities;

namespace RealityLens.Persistence.Configurations;

public class MediaConfiguration : IEntityTypeConfiguration<Media>
{
    public void Configure(EntityTypeBuilder<Media> builder)
    {
        builder.HasKey(x => x.Id);
        builder.Property(x => x.CreatedAt).IsRequired();
        builder.Property(x => x.UpdatedAt).IsRequired();

        builder.Property(x => x.OriginalFileName).IsRequired().HasMaxLength(256);
        builder.Property(x => x.MimeType).IsRequired().HasMaxLength(128);
        builder.Property(x => x.Extension).IsRequired().HasMaxLength(16);
        builder.Property(x => x.StoragePath).IsRequired().HasMaxLength(2048);
        builder.Property(x => x.Checksum).IsRequired().HasMaxLength(64);
        builder.Property(x => x.UploadedByUserId).IsRequired();
        builder.Property(x => x.UploadedAt).IsRequired();
        builder.Property(x => x.Status).HasConversion<string>().IsRequired();

        builder.Property(x => x.ThumbnailPath).HasMaxLength(2048);
        builder.Property(x => x.ProcessingError).HasMaxLength(2048);
        builder.Property(x => x.Width);
        builder.Property(x => x.Height);
        builder.Property(x => x.DurationInSeconds);

        builder.HasIndex(x => x.Checksum).IsUnique();
        builder.HasIndex(x => x.UploadedByUserId);

        builder.HasOne(x => x.UploadedByUser)
               .WithMany()
               .HasForeignKey(x => x.UploadedByUserId)
               .OnDelete(DeleteBehavior.Restrict);
    }
}
