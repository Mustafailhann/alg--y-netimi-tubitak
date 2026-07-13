using System;
using System.Threading.Tasks;
using RealityLens.Application.DTOs;

namespace RealityLens.Application.Interfaces;

public interface IGroundTruthService
{
    Task<GroundTruthResponse> GetByAssessmentIdAsync(Guid assessmentId);
    Task<GroundTruthResponse> CreateAsync(Guid assessmentId, CreateGroundTruthRequest request);
    Task<GroundTruthResponse> UpdateAsync(Guid assessmentId, UpdateGroundTruthRequest request);
}
