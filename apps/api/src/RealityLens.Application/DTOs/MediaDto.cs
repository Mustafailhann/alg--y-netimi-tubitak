using System;
using RealityLens.Domain.Enums;

namespace RealityLens.Application.DTOs;

public class MediaResponse
{
    public Guid Id { get; set; }
    public string OriginalFileName { get; set; } = null!;
    public string MimeType { get; set; } = null!;
    public string Extension { get; set; } = null!;
    public long FileSize { get; set; }
    public string StoragePath { get; set; } = null!;
    public string Checksum { get; set; } = null!;
    public DateTime UploadedAt { get; set; }
    public Guid UploadedByUserId { get; set; }
    public MediaStatus Status { get; set; }
    public string? ThumbnailPath { get; set; }
    public int? Width { get; set; }
    public int? Height { get; set; }
    public double? Duration { get; set; }
    public string? ProcessingError { get; set; }
}

public class UploadMediaRequest
{
    public System.IO.Stream Content { get; set; } = null!;
    public string OriginalFileName { get; set; } = null!;
    public string ContentType { get; set; } = null!;
    public long FileSize { get; set; }
    public Guid UploadedByUserId { get; set; }
}
