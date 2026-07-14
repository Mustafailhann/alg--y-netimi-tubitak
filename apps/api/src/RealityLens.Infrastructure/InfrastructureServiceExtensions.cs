using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.IdentityModel.Tokens;
using RealityLens.Application.Interfaces;
using RealityLens.Application.Options;
using RealityLens.Domain.Entities;
using RealityLens.Infrastructure.Authentication;
using System;
using System.Text;

namespace RealityLens.Infrastructure;

public static class InfrastructureServiceExtensions
{
    public static IServiceCollection AddInfrastructure(
        this IServiceCollection services,
        IConfiguration configuration)
    {
        // Options
        services.Configure<JwtOptions>(configuration.GetSection(JwtOptions.SectionName));
        services.Configure<PasswordOptions>(options => 
        {
            options.RequiredLength = 8;
            options.RequireDigit = true;
            options.RequireLowercase = true;
            options.RequireUppercase = true;
            options.RequireNonAlphanumeric = true;
        });

        // Identity Services natively
        services.AddSingleton<IPasswordHasher<User>, PasswordHasher<User>>();
        services.AddScoped<ITokenService, TokenService>();

        // Authentication & JWT
        services
            .AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
            .AddJwtBearer(options =>
            {
                options.TokenValidationParameters = new TokenValidationParameters
                {
                    ValidateIssuer = true,
                    ValidateAudience = true,
                    ValidateLifetime = true,
                    ValidateIssuerSigningKey = true,
                    ValidIssuer = configuration["Jwt:Issuer"],
                    ValidAudience = configuration["Jwt:Audience"],
                    IssuerSigningKey = new SymmetricSecurityKey(
                        Encoding.UTF8.GetBytes(configuration["Jwt:Secret"] ?? string.Empty)),
                    ClockSkew = TimeSpan.Zero
                };
            });

        // Authorization
        services.AddAuthorization(options =>
        {
            // Set up default policies if needed based on roles, e.g., AdminOnly.
        });

        services.AddScoped<IFileValidator, RealityLens.Infrastructure.Storage.FileValidator>();
        services.AddScoped<IStorageService, RealityLens.Infrastructure.Storage.CloudinaryStorageService>();

        services.AddScoped<IMediaProcessor, RealityLens.Infrastructure.Processing.ImageProcessor>();
        services.AddScoped<IMediaProcessor, RealityLens.Infrastructure.Processing.VideoProcessor>();

        return services;
    }
}
