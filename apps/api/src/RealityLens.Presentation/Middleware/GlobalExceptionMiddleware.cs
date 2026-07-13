using System;
using System.Collections.Generic;
using System.Net;
using System.Text.Json;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using System.Linq;

namespace RealityLens.Presentation.Middleware;

public class GlobalExceptionMiddleware
{
    private readonly RequestDelegate _next;
    private readonly ILogger<GlobalExceptionMiddleware> _logger;

    public GlobalExceptionMiddleware(RequestDelegate next, ILogger<GlobalExceptionMiddleware> logger)
    {
        _next = next;
        _logger = logger;
    }

    public async Task InvokeAsync(HttpContext context)
    {
        try
        {
            await _next(context);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "An unhandled exception occurred.");
            await HandleExceptionAsync(context, ex);
        }
    }

    private static Task HandleExceptionAsync(HttpContext context, Exception exception)
    {
        context.Response.ContentType = "application/problem+json";

        var statusCode = HttpStatusCode.InternalServerError;
        var message = "An internal server error occurred.";
        var title = "Server Error";

        switch (exception)
        {
            case KeyNotFoundException:
                statusCode = HttpStatusCode.NotFound;
                message = exception.Message;
                title = "Not Found";
                break;
            case InvalidOperationException invEx:
                if (invEx.Message.Contains("in use") || invEx.Message.Contains("already exists"))
                {
                    statusCode = HttpStatusCode.Conflict;
                    title = "Conflict";
                }
                else
                {
                    statusCode = HttpStatusCode.BadRequest;
                    title = "Bad Request";
                }
                message = exception.Message;
                break;
            case FluentValidation.ValidationException valEx:
                statusCode = HttpStatusCode.BadRequest;
                title = "Validation Error";
                var errors = string.Join(", ", valEx.Errors.Select(x => x.ErrorMessage));
                message = errors;
                break;
            case ArgumentException:
                statusCode = HttpStatusCode.BadRequest;
                message = exception.Message;
                title = "Bad Request";
                break;
            // FluentValidation exception could be handled here too if needed
        }

        context.Response.StatusCode = (int)statusCode;
        var result = JsonSerializer.Serialize(new 
        { 
            type = $"https://httpstatuses.com/{(int)statusCode}",
            title = title,
            status = (int)statusCode,
            detail = message,
            traceId = context.TraceIdentifier
        });
        return context.Response.WriteAsync(result);
    }
}
