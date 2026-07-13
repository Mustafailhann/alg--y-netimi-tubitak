using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;
using RealityLens.Application.DTOs.Auth;
using RealityLens.Application.Interfaces;
using RealityLens.Domain.Entities;
using RealityLens.Application.Options;
using System;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace RealityLens.Persistence.Services;

public class AuthenticationService : IAuthenticationService
{
    private readonly RealityLensDbContext _context;
    private readonly IPasswordHasher<User> _passwordHasher;
    private readonly ITokenService _tokenService;
    private readonly JwtOptions _jwtOptions;

    public AuthenticationService(
        RealityLensDbContext context,
        IPasswordHasher<User> passwordHasher,
        ITokenService tokenService,
        IOptions<JwtOptions> jwtOptions)
    {
        _context = context;
        _passwordHasher = passwordHasher;
        _tokenService = tokenService;
        _jwtOptions = jwtOptions.Value;
    }

    public async Task<AuthenticationResponse> LoginAsync(LoginRequest request, CancellationToken cancellationToken = default)
    {
        var user = await _context.Users
            .Include(u => u.Role)
            .FirstOrDefaultAsync(u => u.Email == request.Email, cancellationToken);

        if (user is null)
            throw new UnauthorizedAccessException("Invalid credentials.");

        if (!user.IsActive)
            throw new UnauthorizedAccessException("Account is inactive.");

        var verificationResult = _passwordHasher.VerifyHashedPassword(user, user.PasswordHash, request.Password);
        if (verificationResult == PasswordVerificationResult.Failed)
            throw new UnauthorizedAccessException("Invalid credentials.");

        return await IssueTokensAsync(user, cancellationToken);
    }

    public async Task<AuthenticationResponse> RefreshAsync(RefreshRequest request, CancellationToken cancellationToken = default)
    {
        // NOTE (MVP): Refresh tokens are stored as plaintext for MVP.
        // Future: store as SHA-256 hash, compare against hashed values.
        var storedToken = await _context.RefreshTokens
            .Include(rt => rt.User)
            .ThenInclude(u => u.Role)
            .FirstOrDefaultAsync(rt => rt.Token == request.RefreshToken, cancellationToken);

        if (storedToken is null)
            throw new UnauthorizedAccessException("Invalid refresh token.");

        if (!storedToken.IsActive)
            throw new UnauthorizedAccessException("Refresh token has expired or been revoked.");

        // Revoke the current token (Refresh Token Rotation)
        storedToken.Revoke();
        _context.RefreshTokens.Update(storedToken);

        return await IssueTokensAsync(storedToken.User, cancellationToken);
    }

    public async Task LogoutAsync(Guid userId, CancellationToken cancellationToken = default)
    {
        // Revoke all active refresh tokens for the user.
        // Historical tokens are preserved per architecture requirements.
        var activeTokens = await _context.RefreshTokens
            .Where(rt => rt.UserId == userId && rt.RevokedAt == null && rt.ExpiresAt > DateTime.UtcNow)
            .ToListAsync(cancellationToken);

        foreach (var token in activeTokens)
            token.Revoke();

        if (activeTokens.Count > 0)
            await _context.SaveChangesAsync(cancellationToken);
    }

    public async Task<CurrentUserResponse> GetCurrentUserAsync(Guid userId, CancellationToken cancellationToken = default)
    {
        var user = await _context.Users
            .Include(u => u.Role)
            .FirstOrDefaultAsync(u => u.Id == userId, cancellationToken);

        if (user is null)
            throw new UnauthorizedAccessException("User not found.");

        return new CurrentUserResponse(user.Id, user.Email, user.Role.Name);
    }

    private async Task<AuthenticationResponse> IssueTokensAsync(User user, CancellationToken cancellationToken)
    {
        var accessToken = _tokenService.GenerateAccessToken(user);
        var rawRefreshToken = _tokenService.GenerateRefreshToken();
        var expiresAt = DateTime.UtcNow.AddMinutes(_jwtOptions.AccessTokenExpirationMinutes);
        var refreshExpiresAt = DateTime.UtcNow.AddDays(_jwtOptions.RefreshTokenExpirationDays);

        var refreshToken = new RefreshToken(user.Id, rawRefreshToken, refreshExpiresAt);
        _context.RefreshTokens.Add(refreshToken);
        await _context.SaveChangesAsync(cancellationToken);

        return new AuthenticationResponse(accessToken, rawRefreshToken, expiresAt);
    }
}
