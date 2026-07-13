using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using RealityLens.Application.DTOs;

namespace RealityLens.Application.Interfaces;

public interface IMediaService
{
    Task<IEnumerable<MediaResponse>> GetAllAsync();
    Task<MediaResponse> GetByIdAsync(Guid id);
    Task<MediaResponse> UploadAsync(UploadMediaRequest request);
    Task<MediaResponse> ReprocessAsync(Guid id);
    Task DeleteAsync(Guid id);
}
