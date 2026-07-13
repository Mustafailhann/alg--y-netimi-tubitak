using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using RealityLens.Application.DTOs;
using RealityLens.Application.Interfaces;
using RealityLens.Domain.Entities;

namespace RealityLens.Persistence.Services;

public class ManipulationCategoryService : IManipulationCategoryService
{
    private readonly RealityLensDbContext _dbContext;

    public ManipulationCategoryService(RealityLensDbContext dbContext)
    {
        _dbContext = dbContext;
    }

    private static CategoryResponse Map(ManipulationCategory category)
    {
        return new CategoryResponse { Id = category.Id, Name = category.Name, Description = category.Description };
    }

    public async Task<IEnumerable<CategoryResponse>> GetAllAsync()
    {
        var entities = await _dbContext.ManipulationCategories.ToListAsync();
        return entities.Select(Map);
    }

    public async Task<CategoryResponse> GetByIdAsync(Guid id)
    {
        var category = await _dbContext.ManipulationCategories.FindAsync(id);
        if (category == null) throw new KeyNotFoundException("Category not found.");
        return Map(category);
    }

    public async Task<CategoryResponse> CreateAsync(CreateCategoryRequest request)
    {
        var category = new ManipulationCategory(request.Name, request.Description);
        _dbContext.ManipulationCategories.Add(category);
        await _dbContext.SaveChangesAsync();
        return Map(category);
    }

    public async Task<CategoryResponse> UpdateAsync(Guid id, UpdateCategoryRequest request)
    {
        var category = await _dbContext.ManipulationCategories.FindAsync(id);
        if (category == null) throw new KeyNotFoundException("Category not found.");

        category.Update(request.Name, request.Description);

        await _dbContext.SaveChangesAsync();
        return Map(category);
    }

    public async Task DeleteAsync(Guid id)
    {
        var category = await _dbContext.ManipulationCategories.FindAsync(id);
        if (category == null) throw new KeyNotFoundException("Category not found.");

        bool inUse = await _dbContext.Assessments.AnyAsync(a => a.GroundTruth != null && a.GroundTruth.ManipulationCategoryId == id) ||
                     await _dbContext.GroundTruths.AnyAsync(g => g.ManipulationCategoryId == id);

        if (inUse)
        {
            throw new InvalidOperationException("Category is in use by an existing Assessment or GroundTruth.");
        }

        _dbContext.ManipulationCategories.Remove(category);
        await _dbContext.SaveChangesAsync();
    }
}
