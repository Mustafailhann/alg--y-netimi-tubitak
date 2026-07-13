using System;
using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Hosting;
using RealityLens.Application.Interfaces;

namespace RealityLens.Infrastructure.Storage;

public class LocalStorageService : IStorageService
{
    private readonly IWebHostEnvironment _env;

    public LocalStorageService(IWebHostEnvironment env)
    {
        _env = env;
    }

    public async Task<string> SaveFileAsync(Stream content, string extension, string folder = "originals")
    {
        var uploadsFolder = Path.Combine(GetBaseWebRootPath(), "uploads", folder);
        if (!Directory.Exists(uploadsFolder))
        {
            Directory.CreateDirectory(uploadsFolder);
        }

        var uniqueFileName = Guid.NewGuid().ToString("N") + extension;
        var filePath = Path.Combine(uploadsFolder, uniqueFileName);

        using (var fileStream = new FileStream(filePath, FileMode.Create))
        {
            await content.CopyToAsync(fileStream);
        }

        return $"/uploads/{folder}/{uniqueFileName}";
    }

    public Task DeleteFileAsync(string storagePath)
    {
        if (string.IsNullOrWhiteSpace(storagePath)) return Task.CompletedTask;

        var filePath = GetPhysicalPath(storagePath);
        if (File.Exists(filePath))
        {
            File.Delete(filePath);
        }

        return Task.CompletedTask;
    }

    public string GetPhysicalPath(string relativePath)
    {
        if (string.IsNullOrWhiteSpace(relativePath)) return string.Empty;
        var relativeClean = relativePath.TrimStart('/').Replace('/', Path.DirectorySeparatorChar);
        return Path.Combine(GetBaseWebRootPath(), relativeClean);
    }

    private string GetBaseWebRootPath()
    {
        return string.IsNullOrWhiteSpace(_env.WebRootPath) 
            ? Path.Combine(_env.ContentRootPath, "wwwroot") 
            : _env.WebRootPath;
    }
}
