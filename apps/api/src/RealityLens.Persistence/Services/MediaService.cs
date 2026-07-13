using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using RealityLens.Application.DTOs;
using RealityLens.Application.Interfaces;
using RealityLens.Domain.Entities;
using Microsoft.Extensions.Logging;

namespace RealityLens.Persistence.Services;

public class MediaService : IMediaService
{
    private readonly RealityLensDbContext _dbContext;
    private readonly IStorageService _storageService;
    private readonly IFileValidator _fileValidator;
    private readonly Microsoft.Extensions.Logging.ILogger<MediaService> _logger;
    private readonly IEnumerable<IMediaProcessor> _processors;

    public MediaService(
        RealityLensDbContext dbContext, 
        IStorageService storageService, 
        IFileValidator fileValidator, 
        Microsoft.Extensions.Logging.ILogger<MediaService> logger,
        IEnumerable<IMediaProcessor> processors)
    {
        _dbContext = dbContext;
        _storageService = storageService;
        _fileValidator = fileValidator;
        _logger = logger;
        _processors = processors;
    }

    private static MediaResponse Map(Media media)
    {
        return new MediaResponse 
        { 
            Id = media.Id, 
            OriginalFileName = media.OriginalFileName, 
            MimeType = media.MimeType, 
            Extension = media.Extension,
            FileSize = media.FileSize, 
            StoragePath = media.StoragePath, 
            Checksum = media.Checksum,
            UploadedAt = media.UploadedAt,
            UploadedByUserId = media.UploadedByUserId,
            Status = media.Status,
            ThumbnailPath = media.ThumbnailPath,
            Width = media.Width,
            Height = media.Height,
            Duration = media.DurationInSeconds,
            ProcessingError = media.ProcessingError
        };
    }

    public async Task<IEnumerable<MediaResponse>> GetAllAsync()
    {
        var entities = await _dbContext.Media.ToListAsync();
        return entities.Select(Map);
    }

    public async Task<MediaResponse> GetByIdAsync(Guid id)
    {
        var m = await _dbContext.Media.FindAsync(id);
        if (m == null) throw new KeyNotFoundException("Media not found.");
        return Map(m);
    }

    public async Task<MediaResponse> UploadAsync(UploadMediaRequest request)
    {
        _fileValidator.Validate(request.Content, request.OriginalFileName, request.ContentType);

        string checksum = ComputeSha256(request.Content);

        bool isDuplicate = await _dbContext.Media.AnyAsync(m => m.Checksum == checksum);
        if (isDuplicate)
        {
            throw new InvalidOperationException("Duplicate file detected.");
        }

        string extension = System.IO.Path.GetExtension(request.OriginalFileName).ToLowerInvariant();
        string storagePath = await _storageService.SaveFileAsync(request.Content, extension, "originals");

        var media = new Media(
            request.OriginalFileName, 
            request.ContentType, 
            extension, 
            request.FileSize, 
            storagePath, 
            checksum, 
            request.UploadedByUserId);

        // Process Media
        string? thumbnailStoragePath = null;
        var processor = _processors.FirstOrDefault(p => p.CanProcess(request.ContentType));
        
        if (processor != null)
        {
            media.MarkAsProcessing();
            try
            {
                var result = await processor.ProcessAsync(request.Content);
                try
                {
                    if (result.ThumbnailStream != null)
                    {
                        thumbnailStoragePath = await _storageService.SaveFileAsync(result.ThumbnailStream, result.ThumbnailExtension ?? ".jpg", "thumbnails");
                    }
                    
                    media.MarkAsReady(thumbnailStoragePath, result.Width, result.Height, result.DurationInSeconds);
                }
                finally
                {
                    if (result.ThumbnailStream != null)
                    {
                        await result.ThumbnailStream.DisposeAsync();
                    }
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Media processing failed for {FileName}", request.OriginalFileName);
                media.MarkAsFailed(ex.Message);
            }
        }

        _dbContext.Media.Add(media);

        try
        {
            await _dbContext.SaveChangesAsync();
        }
        catch
        {
            try
            {
                await _storageService.DeleteFileAsync(storagePath);
                if (thumbnailStoragePath != null)
                {
                    await _storageService.DeleteFileAsync(thumbnailStoragePath);
                }
            }
            catch (Exception cleanupException)
            {
                _logger.LogError(cleanupException, "Failed to clean up orphaned file(s) after a database update exception.");
            }
            throw;
        }

        return Map(media);
    }

    public async Task<MediaResponse> ReprocessAsync(Guid id)
    {
        var media = await _dbContext.Media.FindAsync(id);
        if (media == null) throw new KeyNotFoundException("Media not found.");

        if (media.Status == RealityLens.Domain.Enums.MediaStatus.Processing)
        {
            throw new InvalidOperationException("Processing is already running for this media.");
        }

        var processor = _processors.FirstOrDefault(p => p.CanProcess(media.MimeType));
        if (processor == null)
        {
            throw new InvalidOperationException("No processor available for this media type.");
        }

        // Delete old thumbnail if exists
        if (!string.IsNullOrWhiteSpace(media.ThumbnailPath))
        {
            try
            {
                await _storageService.DeleteFileAsync(media.ThumbnailPath);
            }
            catch (Exception ex)
            {
                _logger.LogWarning(ex, "Failed to delete old thumbnail: {ThumbnailPath}", media.ThumbnailPath);
            }
        }

        media.MarkAsProcessing();
        await _dbContext.SaveChangesAsync(); // Commit 'Processing' state

        string? thumbnailStoragePath = null;
        try
        {
            var physicalPath = _storageService.GetPhysicalPath(media.StoragePath);
            if (!System.IO.File.Exists(physicalPath))
            {
                throw new System.IO.FileNotFoundException("Original physical file not found.");
            }

            using var fileStream = new System.IO.FileStream(physicalPath, System.IO.FileMode.Open, System.IO.FileAccess.Read);

            var result = await processor.ProcessAsync(fileStream);
            try
            {
                if (result.ThumbnailStream != null)
                {
                    thumbnailStoragePath = await _storageService.SaveFileAsync(result.ThumbnailStream, result.ThumbnailExtension ?? ".jpg", "thumbnails");
                }
                
                media.MarkAsReady(thumbnailStoragePath, result.Width, result.Height, result.DurationInSeconds);
            }
            finally
            {
                if (result.ThumbnailStream != null)
                {
                    await result.ThumbnailStream.DisposeAsync();
                }
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Media processing failed for {FileName}", media.OriginalFileName);
            media.MarkAsFailed(ex.Message);
        }

        try
        {
            await _dbContext.SaveChangesAsync();
        }
        catch
        {
            try
            {
                if (thumbnailStoragePath != null)
                {
                    await _storageService.DeleteFileAsync(thumbnailStoragePath);
                }
            }
            catch (Exception cleanupException)
            {
                _logger.LogError(cleanupException, "Failed to clean up orphaned file(s) after a database update exception.");
            }
            throw;
        }

        return Map(media);
    }

    public async Task DeleteAsync(Guid id)
    {
        var m = await _dbContext.Media.FindAsync(id);
        if (m == null) throw new KeyNotFoundException("Media not found.");

        bool inUse = await _dbContext.Assessments.AnyAsync(a => a.MediaId == id);
        if (inUse)
        {
            throw new InvalidOperationException("Media is in use by an existing Assessment.");
        }

        await _storageService.DeleteFileAsync(m.StoragePath);

        _dbContext.Media.Remove(m);
        await _dbContext.SaveChangesAsync();
    }

    private string ComputeSha256(System.IO.Stream stream)
    {
        using var sha256 = System.Security.Cryptography.SHA256.Create();
        stream.Position = 0;
        var hashBytes = sha256.ComputeHash(stream);
        stream.Position = 0; // reset for next readers (storage service)
        return BitConverter.ToString(hashBytes).Replace("-", "").ToLowerInvariant();
    }
}
