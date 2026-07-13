from fastapi import FastAPI
from app.routers import health

app = FastAPI(
    title="RealityLens AI Service",
    description="Media Manipulation Analysis Service",
    version="0.1.0",
    docs_url="/docs",
    redoc_url="/redoc",
)

app.include_router(health.router)
