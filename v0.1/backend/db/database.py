import sqlite3
from typing import Generator
from contextlib import contextmanager
import os

DATABASE_URL = "sqlite:///./spark.db"

@contextmanager
def get_db() -> Generator[sqlite3.Connection, None, None]:
    """Get database connection with proper cleanup."""
    conn = sqlite3.connect("spark.db")
    conn.row_factory = sqlite3.Row
    try:
        yield conn
    finally:
        conn.close()

def init_db():
    """Initialize database tables."""
    with get_db() as conn:
        cursor = conn.cursor()
        
        # Create foods table
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS foods (
                id TEXT PRIMARY KEY,
                name TEXT NOT NULL,
                category TEXT NOT NULL,
                tags TEXT NOT NULL,  -- JSON string
                protein_g REAL NOT NULL,
                carbs_g REAL NOT NULL,
                fat_g REAL NOT NULL,
                kcal INTEGER NOT NULL,
                areas TEXT NOT NULL,  -- JSON string
                chains TEXT NOT NULL,  -- JSON string
                est_price_range TEXT NOT NULL
            )
        """)
        
        # Create user_prefs table
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS user_prefs (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                diet_style TEXT NOT NULL DEFAULT 'omnivore',
                dislikes TEXT NOT NULL DEFAULT '[]',  -- JSON string
                budget TEXT NOT NULL DEFAULT '$$',
                home_area TEXT,
                recent_picks TEXT NOT NULL DEFAULT '[]'  -- JSON string
            )
        """)
        
        # Create logs table
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS logs (
                id TEXT PRIMARY KEY,
                food_id TEXT NOT NULL,
                timestamp TEXT NOT NULL,
                servings REAL NOT NULL DEFAULT 1.0,
                notes TEXT,
                FOREIGN KEY (food_id) REFERENCES foods (id)
            )
        """)
        
        conn.commit()
