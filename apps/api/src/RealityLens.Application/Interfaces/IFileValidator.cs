using System.IO;

namespace RealityLens.Application.Interfaces;

public interface IFileValidator
{
    void Validate(Stream fileStream, string fileName, string contentType);
}
