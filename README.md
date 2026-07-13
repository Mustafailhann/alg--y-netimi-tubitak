# RealityLens

Media Manipulation Literacy Evaluation System — TÜBİTAK / TEKNOFEST

## Repository Structure

```
RealityLens/
├── apps/
│   ├── client/          Flutter Desktop + Web
│   ├── api/             ASP.NET Core 9 — Clean Architecture
│   └── ai-service/      Python FastAPI — AI Analysis
├── docs/
├── shared/
├── scripts/
├── docker-compose.yml
└── README.md
```

## Prerequisites

| Tool | Version |
|------|---------|
| Flutter SDK | ≥ 3.22 |
| .NET SDK | 9.0 |
| Python | 3.12 |
| Docker + Docker Compose | Latest |
| PostgreSQL | 16 (via Docker) |

## Quick Start

### Start all backend services

```bash
docker compose up -d
```

### Run API locally

```bash
cd apps/api
dotnet run --project src/RealityLens.Presentation
```

### Run AI service locally

```bash
cd apps/ai-service
pip install -r requirements.txt
uvicorn main:app --reload
```

### Run Flutter client

```bash
cd apps/client
flutter pub get
flutter run -d windows
```

## Health Endpoints

| Service | URL |
|---------|-----|
| API | http://localhost:5000/health |
| API Swagger | http://localhost:5000/swagger |
| AI Service | http://localhost:8000/health |
| AI Service Docs | http://localhost:8000/docs |

## Sprint Status

- [x] Sprint 0 — Project Bootstrap
- [ ] Sprint 1 — Domain Entities & Database Schema
