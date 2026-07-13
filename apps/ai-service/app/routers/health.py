from datetime import datetime, UTC
from fastapi import APIRouter
from pydantic import BaseModel


class HealthResponse(BaseModel):
    status: str
    service: str
    timestamp: datetime
    version: str


router = APIRouter(prefix="/health", tags=["Health"])


@router.get("", response_model=HealthResponse, summary="Health Check")
def get_health() -> HealthResponse:
    return HealthResponse(
        status="healthy",
        service="RealityLens AI Service",
        timestamp=datetime.now(UTC),
        version="0.1.0",
    )
