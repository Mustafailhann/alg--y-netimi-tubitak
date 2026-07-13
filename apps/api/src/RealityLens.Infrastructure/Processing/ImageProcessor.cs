using System;
using System.IO;
using System.Threading.Tasks;
using RealityLens.Application.DTOs;
using RealityLens.Application.Interfaces;
using SixLabors.ImageSharp;
using SixLabors.ImageSharp.Processing;

namespace RealityLens.Infrastructure.Processing;

public class ImageProcessor : IMediaProcessor
{
    public bool CanProcess(string mimeType)
    {
        return mimeType.StartsWith("image/", StringComparison.OrdinalIgnoreCase);
    }

    public async Task<MediaProcessingResult> ProcessAsync(Stream content)
    {
        content.Position = 0;
        
        using var image = await Image.LoadAsync(content);
        
        int originalWidth = image.Width;
        int originalHeight = image.Height;

        // Generate thumbnail
        int thumbWidth = 256;
        int thumbHeight = (int)Math.Round((double)image.Height / image.Width * thumbWidth);
        
        if (thumbHeight == 0) thumbHeight = 1;

        image.Mutate(x => x.Resize(thumbWidth, thumbHeight));

        var memoryStream = new MemoryStream();
        await image.SaveAsWebpAsync(memoryStream);
        memoryStream.Position = 0;

        return new MediaProcessingResult
        {
            ThumbnailStream = memoryStream,
            ThumbnailExtension = ".webp",
            Width = originalWidth,
            Height = originalHeight,
            DurationInSeconds = null
        };
    }
}
