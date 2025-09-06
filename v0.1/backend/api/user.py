from fastapi import APIRouter, Depends, HTTPException
from typing import Optional
import json
from db.database import get_db
from models.user_pref import UserPref
import sqlite3

user_router = APIRouter()

@user_router.get("/preferences", response_model=UserPref)
async def get_user_preferences():
    """Get user preferences."""
    with get_db() as db:
        cursor = db.cursor()
        cursor.execute("SELECT * FROM user_prefs ORDER BY id DESC LIMIT 1")
        row = cursor.fetchone()
        
        if not row:
            # Return default preferences if none exist
            return UserPref()
        
        return UserPref(
            diet_style=row["diet_style"],
            dislikes=json.loads(row["dislikes"]),
            budget=row["budget"],
            home_area=row["home_area"],
            recent_picks=json.loads(row["recent_picks"])
        )

@user_router.put("/preferences", response_model=UserPref)
async def update_user_preferences(preferences: UserPref):
    """Update user preferences."""
    with get_db() as db:
        cursor = db.cursor()
        
        # Insert or update preferences
        cursor.execute("""
            INSERT OR REPLACE INTO user_prefs 
            (id, diet_style, dislikes, budget, home_area, recent_picks)
            VALUES (1, ?, ?, ?, ?, ?)
        """, (
            preferences.diet_style,
            json.dumps(preferences.dislikes),
            preferences.budget,
            preferences.home_area,
            json.dumps(preferences.recent_picks)
        ))
        
        db.commit()
        return preferences
