FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

COPY src/RealityLens.Domain/RealityLens.Domain.csproj src/RealityLens.Domain/
COPY src/RealityLens.Application/RealityLens.Application.csproj src/RealityLens.Application/
COPY src/RealityLens.Infrastructure/RealityLens.Infrastructure.csproj src/RealityLens.Infrastructure/
COPY src/RealityLens.Persistence/RealityLens.Persistence.csproj src/RealityLens.Persistence/
COPY src/RealityLens.Presentation/RealityLens.Presentation.csproj src/RealityLens.Presentation/

RUN dotnet restore src/RealityLens.Presentation/RealityLens.Presentation.csproj

COPY . .

RUN dotnet publish src/RealityLens.Presentation/RealityLens.Presentation.csproj \
    --configuration Release \
    --output /app/publish \
    --no-restore

FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
WORKDIR /app
EXPOSE 8080
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "RealityLens.Presentation.dll"]
