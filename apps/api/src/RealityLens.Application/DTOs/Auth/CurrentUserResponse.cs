using System;

namespace RealityLens.Application.DTOs.Auth;

public record CurrentUserResponse(
    Guid Id,
    string Email,
    string Role
);
