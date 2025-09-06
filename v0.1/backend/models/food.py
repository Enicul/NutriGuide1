from pydantic import BaseModel
from typing import List, Dict, Optional
from enum import Enum

class FoodCategory(str, Enum):
    BOWL = "bowl"
    WRAP = "wrap"
    SALAD = "salad"
    SNACK = "snack"
    DRINK = "drink"

class PriceRange(str, Enum):
    LOW = "$"
    MEDIUM = "$$"
    HIGH = "$$$"

class Macros(BaseModel):
    protein_g: float
    carbs_g: float
    fat_g: float

class Availability(BaseModel):
    areas: List[str]
    chains: List[str]

class Food(BaseModel):
    id: str
    name: str
    category: FoodCategory
    tags: List[str]
    macros: Macros
    kcal: int
    availability: Availability
    est_price_range: PriceRange
    
    class Config:
        use_enum_values = True
