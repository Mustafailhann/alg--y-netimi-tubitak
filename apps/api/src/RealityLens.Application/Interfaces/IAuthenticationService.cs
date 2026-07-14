using RealityLens.Application.DTOs.Auth;
using System;
using System.Threading;
using System.Threading.Tasks;

namespace RealityLens.Application.Interfaces;

public interface IAuthenticationService
{
    Task<AuthenticationResponse> LoginAsync(LoginRequest request, CancellationToken cancellationToken = default);
    Task<AuthenticationResponse> DevLoginAsync(DevLoginRequest request, CancellationToken cancellationToken = default);
    Task<AuthenticationResponse> RefreshAsync(RefreshRequest request, CancellationToken cancellationToken = default);
    Task LogoutAsync(Guid userId, CancellationToken cancellationToken = default);
    Task<CurrentUserResponse> GetCurrentUserAsync(Guid userId, CancellationToken cancellationToken = default);
}
