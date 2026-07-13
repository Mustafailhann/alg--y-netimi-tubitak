using System.IO;
using System.Threading.Tasks;
using RealityLens.Application.DTOs;

namespace RealityLens.Application.Interfaces;

public interface IMediaProcessor
{
    bool CanProcess(string mimeType);
    Task<MediaProcessingResult> ProcessAsync(Stream content);
}
