from fastapi import FastAPI
from fastapi.responses import JSONResponse
import os

app = FastAPI(title="SuperClaims Backend", version="1.0.0")


@app.get("/")
def root():
    return {"message": "SuperClaims API is running"}


@app.get("/health/")
def health_check():
    return {"status": "healthy"}


@app.get("/ready/")
def readiness_check():
    return {"status": "ready"}


@app.get("/env/")
def show_environment():
    return {
        "environment": os.getenv("ENVIRONMENT", "dev"),
        "redis_url": os.getenv("REDIS_URL", "not_set")
    }
