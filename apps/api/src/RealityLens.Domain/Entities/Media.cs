using RealityLens.Domain.Common;
using RealityLens.Domain.Enums;
using System.Collections.Generic;

namespace RealityLens.Domain.Entities;

public class Media : BaseEntity
{
    public string OriginalFileName { get; private set; } = null!;
    public string MimeType { get; private set; } = null!;
    public string Extension { get; private set; } = null!;
    public long FileSize { get; private set; }
    public string StoragePath { get; private set; } = null!;
    public string Checksum { get; private set; } = null!;
    public DateTime UploadedAt { get; private set; }
    public Guid UploadedByUserId { get; private set; }
    public User UploadedByUser { get; private set; } = null!;
    public MediaStatus Status { get; private set; }

    public string? ThumbnailPath { get; private set; }
    public int? Width { get; private set; }
    public int? Height { get; private set; }
    public double? DurationInSeconds { get; private set; }
    public string? ProcessingError { get; private set; }

    public IReadOnlyCollection<AIAnalysis> AIAnalyses => _aiAnalyses.AsReadOnly();
    private readonly List<AIAnalysis> _aiAnalyses = new();

    public IReadOnlyCollection<Assessment> Assessments => _assessments.AsReadOnly();
    private readonly List<Assessment> _assessments = new();

    private Media() { } // EF Core

    public Media(string originalFileName, string mimeType, string extension, long fileSize, string storagePath, string checksum, Guid uploadedByUserId)
    {
        OriginalFileName = originalFileName;
        MimeType = mimeType;
        Extension = extension;
        FileSize = fileSize;
        StoragePath = storagePath;
        Checksum = checksum;
        UploadedByUserId = uploadedByUserId;
        UploadedAt = DateTime.UtcNow;
        Status = MediaStatus.Uploaded;
    }

    public void MarkAsProcessing()
    {
        Status = MediaStatus.Processing;
        ProcessingError = null;
        UpdateTimestamp();
    }

    public void MarkAsReady(string? thumbnailPath, int? width, int? height, double? durationInSeconds)
    {
        Status = MediaStatus.Ready;
        ThumbnailPath = thumbnailPath;
        Width = width;
        Height = height;
        DurationInSeconds = durationInSeconds;
        ProcessingError = null;
        UpdateTimestamp();
    }

    public void MarkAsFailed(string error)
    {
        Status = MediaStatus.Failed;
        ProcessingError = error;
        UpdateTimestamp();
    }

    public void MarkAsAnalyzed()
    {
        Status = MediaStatus.AIAnalyzed;
        UpdateTimestamp();
    }

    public void Publish()
    {
        Status = MediaStatus.Published;
        UpdateTimestamp();
    }
}
