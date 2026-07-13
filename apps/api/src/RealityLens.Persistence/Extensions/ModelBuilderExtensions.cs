using System;
using Microsoft.EntityFrameworkCore;
using RealityLens.Domain.Entities;

namespace RealityLens.Persistence.Extensions;

public static class ModelBuilderExtensions
{
    public static void SeedData(this ModelBuilder modelBuilder)
    {
        var adminRoleId = Guid.Parse("11111111-1111-1111-1111-111111111111");
        var teacherRoleId = Guid.Parse("22222222-2222-2222-2222-222222222222");
        var studentRoleId = Guid.Parse("33333333-3333-3333-3333-333333333333");
        var adminUserId = Guid.Parse("55555555-5555-5555-5555-555555555555");
        var faceSwapCategoryId = Guid.Parse("44444444-4444-4444-4444-444444444444");
        var defaultVersion = Guid.Parse("00000000-0000-0000-0000-000000000001");

        var now = new DateTime(2026, 1, 1, 0, 0, 0, DateTimeKind.Utc);

        modelBuilder.Entity<Role>().HasData(
            new { Id = adminRoleId, Name = "Administrator", CreatedAt = now, UpdatedAt = now, IsDeleted = false, Version = defaultVersion },
            new { Id = teacherRoleId, Name = "Teacher", CreatedAt = now, UpdatedAt = now, IsDeleted = false, Version = defaultVersion },
            new { Id = studentRoleId, Name = "Student", CreatedAt = now, UpdatedAt = now, IsDeleted = false, Version = defaultVersion }
        );

        modelBuilder.Entity<ManipulationCategory>().HasData(
            new { Id = faceSwapCategoryId, Name = "FaceSwap", Description = "Replacing one person's face with another (deepfake)", CreatedAt = now, UpdatedAt = now, IsDeleted = false, Version = defaultVersion }
        );

        modelBuilder.Entity<User>().HasData(
            new { 
                Id = adminUserId, 
                Email = "admin@realitylens.gov.tr", 
                PasswordHash = "AQAAAAIAAYagAAAAEGv8DVAzG3eUqtvqQEk3PXiHwO9RCf6olWgqQQFI1oqWAbER6ybTyaENB6MfWBQG9g==", // Real application will set this via initial setup or a command
                IsActive = true, 
                RoleId = adminRoleId,
                CreatedAt = now, 
                UpdatedAt = now,
                IsDeleted = false,
                Version = defaultVersion
            }
        );
    }
}
