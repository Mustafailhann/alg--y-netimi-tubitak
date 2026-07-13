using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using RealityLens.Application.DTOs;

namespace RealityLens.Application.Interfaces;

public interface IManipulationCategoryService
{
    Task<IEnumerable<CategoryResponse>> GetAllAsync();
    Task<CategoryResponse> GetByIdAsync(Guid id);
    Task<CategoryResponse> CreateAsync(CreateCategoryRequest request);
    Task<CategoryResponse> UpdateAsync(Guid id, UpdateCategoryRequest request);
    Task DeleteAsync(Guid id);
}
