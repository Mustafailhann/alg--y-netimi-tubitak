using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using RealityLens.Application.DTOs;

namespace RealityLens.Application.Interfaces;

public interface IAssessmentService
{
    Task<IEnumerable<AssessmentListResponse>> GetAllAsync();
    Task<AssessmentDetailResponse> GetByIdAsync(Guid id);
    Task<AssessmentDetailResponse> CreateAsync(CreateAssessmentRequest request);
    Task<AssessmentDetailResponse> UpdateAsync(Guid id, UpdateAssessmentRequest request);
    Task MarkReadyAsync(Guid id);
    Task PublishAsync(Guid id);
    Task ArchiveAsync(Guid id);
}
