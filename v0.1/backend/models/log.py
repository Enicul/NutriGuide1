from pydantic import BaseModel
from datetime import datetime
from typing import Optional

class Log(BaseModel):
    id: str
    food_id: str
    timestamp: datetime
    servings: float = 1.0
    notes: Optional[str] = None
