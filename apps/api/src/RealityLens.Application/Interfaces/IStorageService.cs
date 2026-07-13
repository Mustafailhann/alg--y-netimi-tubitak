using System.IO;
using System.Threading.Tasks;

namespace RealityLens.Application.Interfaces;

public interface IStorageService
{
    Task<string> SaveFileAsync(Stream content, string extension, string folder = "originals");
    Task DeleteFileAsync(string storagePath);
    string GetPhysicalPath(string relativePath);
}
