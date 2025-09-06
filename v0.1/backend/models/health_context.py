from pydantic import BaseModel
from typing import Literal

class HealthContext(BaseModel):
    sleep_hours: float  # 0-12
    activity_level: Literal["none", "light", "moderate", "intense"]
    mood_energy: Literal["low", "normal", "high"]
