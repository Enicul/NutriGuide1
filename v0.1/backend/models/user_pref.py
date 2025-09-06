from pydantic import BaseModel
from typing import List, Optional
from enum import Enum

class DietStyle(str, Enum):
    OMNIVORE = "omnivore"
    VEGETARIAN = "vegetarian"
    VEGAN = "vegan"
    HALAL = "halal"
    KETO = "keto"

class PriceRange(str, Enum):
    LOW = "$"
    MEDIUM = "$$"
    HIGH = "$$$"

class UserPref(BaseModel):
    diet_style: DietStyle = DietStyle.OMNIVORE
    dislikes: List[str] = []
    budget: PriceRange = PriceRange.MEDIUM
    home_area: Optional[str] = None
    recent_picks: List[str] = []
    
    class Config:
        use_enum_values = True
