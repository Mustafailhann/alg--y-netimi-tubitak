using System;
using System.IO;
using System.Threading.Tasks;
using FFMpegCore;
using RealityLens.Application.DTOs;
using RealityLens.Application.Interfaces;

namespace RealityLens.Infrastructure.Processing;

public class VideoProcessor : IMediaProcessor
{
    public bool CanProcess(string mimeType)
    {
        return mimeType.StartsWith("video/", StringComparison.OrdinalIgnoreCase);
    }

    public async Task<MediaProcessingResult> ProcessAsync(Stream content)
    {
        var tempVideoPath = Path.GetTempFileName() + ".mp4";
        var tempThumbPath = Path.GetTempFileName() + ".jpg";

        try
        {
            content.Position = 0;
            using (var fs = new FileStream(tempVideoPath, FileMode.Create))
            {
                await content.CopyToAsync(fs);
            }

            var mediaInfo = await FFProbe.AnalyseAsync(tempVideoPath);
            
            int width = mediaInfo.PrimaryVideoStream?.Width ?? 0;
            int height = mediaInfo.PrimaryVideoStream?.Height ?? 0;
            double duration = mediaInfo.Duration.TotalSeconds;

            bool success = await FFMpeg.SnapshotAsync(tempVideoPath, tempThumbPath, new System.Drawing.Size(256, (int)Math.Round((double)height / width * 256)), TimeSpan.FromSeconds(Math.Min(1, duration / 2)));

            MemoryStream ms = null;
            if (success && File.Exists(tempThumbPath))
            {
                var thumbBytes = await File.ReadAllBytesAsync(tempThumbPath);
                ms = new MemoryStream(thumbBytes);
            }

            return new MediaProcessingResult
            {
                ThumbnailStream = ms,
                ThumbnailExtension = ".jpg",
                Width = width > 0 ? width : null,
                Height = height > 0 ? height : null,
                DurationInSeconds = duration
            };
        }
        finally
        {
            if (File.Exists(tempVideoPath)) File.Delete(tempVideoPath);
            if (File.Exists(tempThumbPath)) File.Delete(tempThumbPath);
        }
    }
}
