using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using RealityLens.Application.Interfaces;
using RealityLens.Persistence.Services;

namespace RealityLens.Persistence;

public static class PersistenceServiceExtensions
{
    public static IServiceCollection AddPersistence(this IServiceCollection services, IConfiguration configuration)
    {
        services.AddDbContext<RealityLensDbContext>(options =>
            options.UseNpgsql(configuration.GetConnectionString("DefaultConnection")));

        services.AddScoped<IAuthenticationService, AuthenticationService>();
        services.AddScoped<IManipulationCategoryService, ManipulationCategoryService>();
        services.AddScoped<IMediaService, MediaService>();
        services.AddScoped<IAssessmentService, AssessmentService>();
        services.AddScoped<IGroundTruthService, GroundTruthService>();
        services.AddScoped<IAnnotationService, AnnotationService>();
        
        services.AddScoped<RealityLens.Domain.Repositories.ITrainingPackRepository, RealityLens.Persistence.Repositories.TrainingPackRepository>();
        services.AddScoped<RealityLens.Domain.Repositories.ITrainingSessionRepository, RealityLens.Persistence.Repositories.TrainingSessionRepository>();

        services.AddScoped<RealityLens.Application.CQRS.Interfaces.IApplicationDbContext>(provider => provider.GetRequiredService<RealityLensDbContext>());

        return services;
    }
}
