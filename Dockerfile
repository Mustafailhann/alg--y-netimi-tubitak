FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# Copy csproj files and restore as distinct layers
COPY ["apps/api/src/RealityLens.Presentation/RealityLens.Presentation.csproj", "apps/api/src/RealityLens.Presentation/"]
COPY ["apps/api/src/RealityLens.Application/RealityLens.Application.csproj", "apps/api/src/RealityLens.Application/"]
COPY ["apps/api/src/RealityLens.Domain/RealityLens.Domain.csproj", "apps/api/src/RealityLens.Domain/"]
COPY ["apps/api/src/RealityLens.Infrastructure/RealityLens.Infrastructure.csproj", "apps/api/src/RealityLens.Infrastructure/"]
COPY ["apps/api/src/RealityLens.Persistence/RealityLens.Persistence.csproj", "apps/api/src/RealityLens.Persistence/"]

RUN dotnet restore "apps/api/src/RealityLens.Presentation/RealityLens.Presentation.csproj"

# Copy everything else and build
COPY . .
WORKDIR "/src/apps/api/src/RealityLens.Presentation"
RUN dotnet build "RealityLens.Presentation.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "RealityLens.Presentation.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS final
WORKDIR /app
COPY --from=publish /app/publish .

# Expose port 8080 which is the default for .NET 8+ containers
EXPOSE 8080
ENV ASPNETCORE_URLS=http://+:8080
ENV ASPNETCORE_ENVIRONMENT=Development

ENTRYPOINT ["dotnet", "RealityLens.Presentation.dll"]
