from fastapi import APIRouter, Depends, HTTPException
from typing import List, Optional, Dict, Any
import json
from db.database import get_db
from models.food import Food, FoodCategory
from models.user_pref import UserPref
from models.health_context import HealthContext
from services.ai_service import ai_service
from services.nutrition_engine import nutrition_engine
import sqlite3

food_router = APIRouter()

def get_food_from_row(row) -> Food:
    """Convert database row to Food model."""
    return Food(
        id=row["id"],
        name=row["name"],
        category=row["category"],
        tags=json.loads(row["tags"]),
        macros={
            "protein_g": row["protein_g"],
            "carbs_g": row["carbs_g"],
            "fat_g": row["fat_g"]
        },
        kcal=row["kcal"],
        availability={
            "areas": json.loads(row["areas"]),
            "chains": json.loads(row["chains"])
        },
        est_price_range=row["est_price_range"]
    )

@food_router.get("/", response_model=List[Food])
async def get_foods(
    category: Optional[FoodCategory] = None
):
    """Get all foods, optionally filtered by category."""
    with get_db() as db:
        cursor = db.cursor()
        
        if category:
            cursor.execute("SELECT * FROM foods WHERE category = ?", (category.value,))
        else:
            cursor.execute("SELECT * FROM foods")
        
        rows = cursor.fetchall()
        return [get_food_from_row(row) for row in rows]

@food_router.get("/{food_id}", response_model=Food)
async def get_food(food_id: str):
    """Get a specific food by ID."""
    with get_db() as db:
        cursor = db.cursor()
        cursor.execute("SELECT * FROM foods WHERE id = ?", (food_id,))
        row = cursor.fetchone()
        
        if not row:
            raise HTTPException(status_code=404, detail="Food not found")
        
        return get_food_from_row(row)

@food_router.post("/recommend/", response_model=List[Food])
async def recommend_foods(
    user_pref: UserPref,
    health_context: HealthContext,
    limit: int = 5
):
    """Get AI-powered food recommendations based on user preferences and health context."""
    with get_db() as db:
        cursor = db.cursor()
        cursor.execute("SELECT * FROM foods")
        all_foods = cursor.fetchall()
        
        # Convert to dict format for AI service
        available_foods = [dict(row) for row in all_foods]
        
        # Convert user preferences and health context to dict
        user_prefs_dict = {
            "diet_style": user_pref.diet_style,
            "dislikes": user_pref.dislikes,
            "budget": user_pref.budget,
            "home_area": user_pref.home_area
        }
        
        health_context_dict = {
            "sleep_hours": health_context.sleep_hours,
            "activity_level": health_context.activity_level,
            "mood": health_context.mood_energy
        }
        
        try:
            # Get AI recommendations
            ai_recommendations = await ai_service.get_food_recommendations(
                user_prefs_dict, 
                health_context_dict, 
                available_foods, 
                limit
            )
            
            # Get recommended food IDs
            recommended_ids = [rec["food_id"] for rec in ai_recommendations]
            
            # Fetch recommended foods from database
            if recommended_ids:
                placeholders = ','.join(['?' for _ in recommended_ids])
                cursor.execute(f"SELECT * FROM foods WHERE id IN ({placeholders})", recommended_ids)
                recommended_rows = cursor.fetchall()
                
                # Sort by AI recommendation order
                food_dict = {row["id"]: row for row in recommended_rows}
                sorted_foods = [food_dict[fid] for fid in recommended_ids if fid in food_dict]
                
                return [get_food_from_row(row) for row in sorted_foods]
            else:
                # Fallback to simple recommendations
                return await _fallback_recommendations(cursor, health_context, limit)
                
        except Exception as e:
            # Fallback to simple recommendations if AI fails
            return await _fallback_recommendations(cursor, health_context, limit)

async def _fallback_recommendations(cursor, health_context: HealthContext, limit: int) -> List[Food]:
    """Fallback recommendation logic when AI is unavailable."""
    if health_context.activity_level == "intense":
        # High protein foods for intense activity
        cursor.execute("""
            SELECT * FROM foods 
            WHERE protein_g > 25 
            ORDER BY protein_g DESC 
            LIMIT ?
        """, (limit,))
    elif health_context.mood_energy == "low":
        # Comfort foods for low energy
        cursor.execute("""
            SELECT * FROM foods 
            WHERE kcal > 300 
            ORDER BY kcal DESC 
            LIMIT ?
        """, (limit,))
    else:
        # Balanced recommendations
        cursor.execute("""
            SELECT * FROM foods 
            ORDER BY RANDOM() 
            LIMIT ?
        """, (limit,))
    
    rows = cursor.fetchall()
    return [get_food_from_row(row) for row in rows]

@food_router.post("/analyze-meal/")
async def analyze_meal_balance(
    meal_foods: List[Food],
    daily_goals: Dict[str, Any],
    meal_type: str = "lunch"
):
    """Analyze meal balance using AI nutrition engine."""
    try:
        # Convert Food objects to dict format
        meal_foods_dict = [
            {
                "name": food.name,
                "kcal": food.kcal,
                "macros": food.macros
            }
            for food in meal_foods
        ]
        
        analysis = await nutrition_engine.analyze_meal_balance(
            meal_foods_dict, 
            daily_goals, 
            meal_type
        )
        
        return analysis
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error analyzing meal: {str(e)}")

@food_router.post("/suggest-swaps/")
async def suggest_food_swaps(
    current_food: Food,
    user_pref: UserPref,
    available_foods: List[Food]
):
    """Suggest healthier food swaps using AI."""
    try:
        current_food_dict = {
            "name": current_food.name,
            "kcal": current_food.kcal,
            "macros": current_food.macros
        }
        
        user_prefs_dict = {
            "diet_style": user_pref.diet_style,
            "dislikes": user_pref.dislikes,
            "budget": user_pref.budget
        }
        
        available_foods_dict = [
            {
                "id": food.id,
                "name": food.name,
                "kcal": food.kcal,
                "macros": food.macros
            }
            for food in available_foods
        ]
        
        swaps = await nutrition_engine.suggest_food_swaps(
            current_food_dict, 
            user_prefs_dict, 
            available_foods_dict
        )
        
        return {"suggestions": swaps}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error suggesting swaps: {str(e)}")

@food_router.get("/ai-usage-stats/")
async def get_ai_usage_stats():
    """Get AI service usage statistics for cost monitoring."""
    return ai_service.get_usage_stats()
