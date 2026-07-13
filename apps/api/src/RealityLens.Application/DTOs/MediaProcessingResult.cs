using System.IO;

namespace RealityLens.Application.DTOs;

public class MediaProcessingResult
{
    public MemoryStream? ThumbnailStream { get; set; }
    public string? ThumbnailExtension { get; set; }
    public int? Width { get; set; }
    public int? Height { get; set; }
    public double? DurationInSeconds { get; set; }
}
