namespace RealityLens.Application.DTOs.Auth;

public record AuthenticationResponse(
    string AccessToken,
    string RefreshToken,
    DateTime ExpiresAt
);
