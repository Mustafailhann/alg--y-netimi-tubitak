using FluentValidation;
using Microsoft.Extensions.DependencyInjection;
using System.Reflection;
using System.Linq;

namespace RealityLens.Application;

public static class ApplicationServiceExtensions
{
    public static IServiceCollection AddApplication(this IServiceCollection services)
    {
        services.AddValidatorsFromAssembly(Assembly.GetExecutingAssembly());

        // Dispatchers
        services.AddScoped<RealityLens.Application.CQRS.Interfaces.ICommandDispatcher, RealityLens.Application.CQRS.Dispatchers.CommandDispatcher>();
        services.AddScoped<RealityLens.Application.CQRS.Interfaces.IQueryDispatcher, RealityLens.Application.CQRS.Dispatchers.QueryDispatcher>();

        // Services
        services.AddScoped<RealityLens.Application.Interfaces.IScoringService, RealityLens.Application.Services.ScoringService>();

        // Register Handlers via Reflection
        var assembly = Assembly.GetExecutingAssembly();
        
        var handlerTypes = assembly.GetTypes()
            .Where(t => t.GetInterfaces().Any(i => 
                i.IsGenericType && 
                (i.GetGenericTypeDefinition() == typeof(RealityLens.Application.CQRS.Interfaces.ICommandHandler<>) ||
                 i.GetGenericTypeDefinition() == typeof(RealityLens.Application.CQRS.Interfaces.ICommandHandler<,>) ||
                 i.GetGenericTypeDefinition() == typeof(RealityLens.Application.CQRS.Interfaces.IQueryHandler<,>))))
            .ToList();

        foreach (var type in handlerTypes)
        {
            var interfaces = type.GetInterfaces().Where(i => 
                i.IsGenericType && 
                (i.GetGenericTypeDefinition() == typeof(RealityLens.Application.CQRS.Interfaces.ICommandHandler<>) ||
                 i.GetGenericTypeDefinition() == typeof(RealityLens.Application.CQRS.Interfaces.ICommandHandler<,>) ||
                 i.GetGenericTypeDefinition() == typeof(RealityLens.Application.CQRS.Interfaces.IQueryHandler<,>)));

            foreach (var @interface in interfaces)
            {
                services.AddScoped(@interface, type);
            }
        }

        return services;
    }
}
