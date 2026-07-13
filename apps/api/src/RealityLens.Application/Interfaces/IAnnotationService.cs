using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using RealityLens.Application.DTOs;

namespace RealityLens.Application.Interfaces;

public interface IAnnotationService
{
    Task<AnnotationResponse> GetByIdAsync(Guid id);
    Task<IEnumerable<AnnotationResponse>> GetByGroundTruthAsync(Guid groundTruthId, Guid? userId = null);
    Task<IEnumerable<AnnotationResponse>> GetParticipantAnnotationAsync(Guid groundTruthId, Guid participantId);
    Task<AnnotationResponse> CreateAsync(CreateAnnotationRequest request, Guid userId);
    Task<AnnotationResponse> UpdateAsync(Guid id, UpdateAnnotationRequest request, Guid userId);
    Task DeleteAsync(Guid id, Guid userId);
}
