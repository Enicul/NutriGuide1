from fastapi import FastAPI, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from contextlib import asynccontextmanager
import uvicorn

from db import init_db, seed_foods
from api import food_router, user_router, log_router
from api.nutrition import nutrition_router

@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup
    init_db()
    seed_foods()
    yield
    # Shutdown
    pass

app = FastAPI(
    title="Spark Food API",
    description="AI-powered food recommendation system",
    version="1.0.0",
    lifespan=lifespan
)

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:3000"],  # React app
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
app.include_router(food_router, prefix="/api/foods", tags=["foods"])
app.include_router(user_router, prefix="/api/users", tags=["users"])
app.include_router(log_router, prefix="/api/logs", tags=["logs"])
app.include_router(nutrition_router, prefix="/api/nutrition", tags=["nutrition"])

@app.get("/")
async def root():
    return {"message": "Spark Food API is running!"}

@app.get("/health")
async def health_check():
    return {"status": "healthy"}

if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
