from fastapi import APIRouter, Depends, HTTPException
from typing import List
from datetime import datetime
import uuid
from db.database import get_db
from models.log import Log
import sqlite3

log_router = APIRouter()

@log_router.post("/", response_model=Log)
async def create_log(
    food_id: str,
    servings: float = 1.0,
    notes: str = None
):
    """Log a food consumption."""
    with get_db() as db:
        # Verify food exists
        cursor = db.cursor()
        cursor.execute("SELECT id FROM foods WHERE id = ?", (food_id,))
        if not cursor.fetchone():
            raise HTTPException(status_code=404, detail="Food not found")
        
        # Create log entry
        log_id = str(uuid.uuid4())
        timestamp = datetime.now().isoformat()
        
        cursor.execute("""
            INSERT INTO logs (id, food_id, timestamp, servings, notes)
            VALUES (?, ?, ?, ?, ?)
        """, (log_id, food_id, timestamp, servings, notes))
        
        db.commit()
        
        return Log(
            id=log_id,
            food_id=food_id,
            timestamp=datetime.fromisoformat(timestamp),
            servings=servings,
            notes=notes
        )

@log_router.get("/", response_model=List[Log])
async def get_logs(limit: int = 50):
    """Get recent food logs."""
    with get_db() as db:
        cursor = db.cursor()
        cursor.execute("""
            SELECT * FROM logs 
            ORDER BY timestamp DESC 
            LIMIT ?
        """, (limit,))
        
        rows = cursor.fetchall()
        return [
            Log(
                id=row["id"],
                food_id=row["food_id"],
                timestamp=datetime.fromisoformat(row["timestamp"]),
                servings=row["servings"],
                notes=row["notes"]
            )
            for row in rows
        ]
