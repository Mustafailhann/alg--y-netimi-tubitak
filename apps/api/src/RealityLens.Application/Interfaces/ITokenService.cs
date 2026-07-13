using RealityLens.Domain.Entities;
using System.Security.Claims;

namespace RealityLens.Application.Interfaces;

public interface ITokenService
{
    string GenerateAccessToken(User user);
    string GenerateRefreshToken();
    string GenerateParticipantToken(System.Guid participantId, System.Guid sessionId);
    ClaimsPrincipal? ValidateToken(string token);
}
