using System;
using System.IO;
using System.Linq;
using System.Text;
using RealityLens.Application.Interfaces;

namespace RealityLens.Infrastructure.Storage;

public class FileValidator : IFileValidator
{
    private const long MaxFileSize = 100 * 1024 * 1024; // 100 MB
    private readonly string[] AllowedExtensions = { ".jpg", ".jpeg", ".png", ".webp", ".mp4" };
    private readonly string[] AllowedMimeTypes = { "image/jpeg", "image/png", "image/webp", "video/mp4" };

    public void Validate(Stream fileStream, string fileName, string contentType)
    {
        if (fileStream == null || fileStream.Length == 0)
            throw new ArgumentException("File is empty.");

        if (fileStream.Length > MaxFileSize)
            throw new ArgumentException($"File size exceeds the limit of {MaxFileSize / (1024 * 1024)} MB.");

        var ext = Path.GetExtension(fileName).ToLowerInvariant();
        if (!AllowedExtensions.Contains(ext))
            throw new ArgumentException("Unsupported file extension.");

        if (!AllowedMimeTypes.Contains(contentType.ToLowerInvariant()))
            throw new ArgumentException("Unsupported MIME type.");

        // Magic number validation
        fileStream.Position = 0;
        var forensicLog = new StringBuilder();
        forensicLog.AppendLine("\n[FORENSIC] === FILE VALIDATOR ===");
        forensicLog.AppendLine($"[FORENSIC] Filename: {fileName}");
        forensicLog.AppendLine($"[FORENSIC] Extension: {ext}");
        forensicLog.AppendLine($"[FORENSIC] Content-Type: {contentType}");
        forensicLog.AppendLine($"[FORENSIC] File Length: {fileStream.Length}");
        forensicLog.AppendLine($"[FORENSIC] Current Stream Position: {fileStream.Position}");
        forensicLog.AppendLine($"[FORENSIC] CanRead: {fileStream.CanRead}");
        forensicLog.AppendLine($"[FORENSIC] CanSeek: {fileStream.CanSeek}");
        
        long positionBeforeRead = fileStream.Position;
        forensicLog.AppendLine($"[FORENSIC] Position before read: {positionBeforeRead}");
        
        var buffer = new byte[32];
        var bytesRead = fileStream.Read(buffer, 0, buffer.Length);
        
        forensicLog.AppendLine($"[FORENSIC] Bytes actually read: {bytesRead}");
        forensicLog.AppendLine($"[FORENSIC] Number of bytes requested: {buffer.Length}");
        forensicLog.AppendLine($"[FORENSIC] Position after read: {fileStream.Position}");
        forensicLog.AppendLine($"[FORENSIC] First 32 bytes (HEX): {BitConverter.ToString(buffer)}");
        
        fileStream.Position = 0;
        forensicLog.AppendLine($"[FORENSIC] Reset behaviour (position after reset): {fileStream.Position}");
        
        bool isValid = false;
        forensicLog.AppendLine($"[FORENSIC] switch(ext) -> {ext}");
        
        switch (ext)
        {
            case ".jpg":
            case ".jpeg":
                forensicLog.AppendLine("[FORENSIC] selected validation branch: JPEG");
                forensicLog.AppendLine("[FORENSIC] expected magic bytes: FF D8 FF");
                isValid = bytesRead >= 3 && buffer[0] == 0xFF && buffer[1] == 0xD8 && buffer[2] == 0xFF;
                break;
            case ".png":
                forensicLog.AppendLine("[FORENSIC] selected validation branch: PNG");
                forensicLog.AppendLine("[FORENSIC] expected magic bytes: 89 50 4E 47");
                isValid = bytesRead >= 4 && buffer[0] == 0x89 && buffer[1] == 0x50 && buffer[2] == 0x4E && buffer[3] == 0x47;
                break;
            case ".webp":
                forensicLog.AppendLine("[FORENSIC] selected validation branch: WEBP");
                forensicLog.AppendLine("[FORENSIC] expected magic bytes: 52 49 46 46 (starts at 0) and 57 45 42 50 (starts at 8)");
                isValid = bytesRead >= 12 &&
                          buffer[0] == 0x52 && buffer[1] == 0x49 && buffer[2] == 0x46 && buffer[3] == 0x46 &&
                          buffer[8] == 0x57 && buffer[9] == 0x45 && buffer[10] == 0x42 && buffer[11] == 0x50;
                break;
            case ".mp4":
                forensicLog.AppendLine("[FORENSIC] selected validation branch: MP4");
                isValid = bytesRead >= 8 && buffer[4] == 0x66 && buffer[5] == 0x74 && buffer[6] == 0x79 && buffer[7] == 0x70;
                break;
            default:
                forensicLog.AppendLine("[FORENSIC] selected validation branch: default");
                break;
        }

        forensicLog.AppendLine($"[FORENSIC] IsValidSignature result: {isValid}");
        forensicLog.AppendLine("[FORENSIC] ===========================");

        if (!isValid)
            throw new ArgumentException($"Invalid file signature.\nFORENSIC DATA:\n{forensicLog.ToString()}");
    }
}
