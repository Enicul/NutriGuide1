"""
AI-Powered Nutrition Analysis API Endpoints
"""
from fastapi import APIRouter, HTTPException
from typing import List, Dict, Any, Optional
from datetime import datetime, timedelta
from models.food import Food
from models.user_pref import UserPref
from models.health_context import HealthContext
from services.nutrition_engine import nutrition_engine
from services.ai_service import ai_service
import json

nutrition_router = APIRouter()

@nutrition_router.post("/daily-goals/")
async def calculate_daily_goals(
    user_profile: Dict[str, Any],
    health_context: HealthContext
):
    """Calculate personalized daily nutrition goals using AI."""
    try:
        user_profile_dict = {
            "age": user_profile.get("age", 30),
            "weight": user_profile.get("weight", 70),
            "height": user_profile.get("height", 170),
            "goals": user_profile.get("goals", "maintain")
        }
        
        health_context_dict = {
            "activity_level": health_context.activity_level,
            "sleep_hours": health_context.sleep_hours,
            "mood": health_context.mood_energy
        }
        
        goals = await nutrition_engine.calculate_daily_nutrition_goals(
            user_profile_dict, 
            health_context_dict
        )
        
        return goals
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error calculating goals: {str(e)}")

@nutrition_router.post("/meal-plan/")
async def generate_meal_plan(
    user_pref: UserPref,
    health_context: HealthContext,
    available_foods: List[Food],
    days: int = 3
):
    """Generate AI-powered meal plan."""
    try:
        user_prefs_dict = {
            "diet_style": user_pref.diet_style,
            "dislikes": user_pref.dislikes,
            "budget": user_pref.budget,
            "home_area": user_pref.home_area
        }
        
        health_context_dict = {
            "activity_level": health_context.activity_level,
            "sleep_hours": health_context.sleep_hours,
            "mood": health_context.mood_energy
        }
        
        available_foods_dict = [
            {
                "id": food.id,
                "name": food.name,
                "kcal": food.kcal,
                "macros": food.macros,
                "category": food.category,
                "tags": food.tags
            }
            for food in available_foods
        ]
        
        meal_plan = await nutrition_engine.generate_meal_plan(
            user_prefs_dict, 
            health_context_dict, 
            available_foods_dict, 
            days
        )
        
        return meal_plan
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error generating meal plan: {str(e)}")

@nutrition_router.post("/trends/")
async def analyze_nutrition_trends(
    consumption_logs: List[Dict[str, Any]],
    time_period: str = "week"
):
    """Analyze nutrition trends over time using AI."""
    try:
        trends = await nutrition_engine.analyze_nutrition_trends(
            consumption_logs, 
            time_period
        )
        
        return trends
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error analyzing trends: {str(e)}")

@nutrition_router.post("/balance-score/")
async def calculate_balance_score(
    consumed_foods: List[Food],
    daily_goals: Dict[str, Any]
):
    """Calculate overall nutrition balance score using AI."""
    try:
        consumed_foods_dict = [
            {
                "name": food.name,
                "kcal": food.kcal,
                "macros": food.macros
            }
            for food in consumed_foods
        ]
        
        analysis = await nutrition_engine.analyze_meal_balance(
            consumed_foods_dict, 
            daily_goals, 
            "daily"
        )
        
        return {
            "balance_score": analysis.get("balance_score", 0.5),
            "strengths": analysis.get("strengths", []),
            "improvements": analysis.get("improvements", []),
            "next_meal_focus": analysis.get("next_meal_focus", "balance")
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error calculating balance score: {str(e)}")

@nutrition_router.post("/smart-recommendations/")
async def get_smart_recommendations(
    user_pref: UserPref,
    health_context: HealthContext,
    recent_logs: List[Dict[str, Any]],
    available_foods: List[Food],
    limit: int = 5
):
    """Get smart recommendations considering recent consumption patterns."""
    try:
        # Analyze recent patterns
        if recent_logs:
            trend_analysis = await nutrition_engine.analyze_nutrition_trends(
                recent_logs, 
                "week"
            )
        else:
            trend_analysis = {"trends": [], "concerns": [], "strengths": []}
        
        # Get base recommendations
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
        
        available_foods_dict = [
            {
                "id": food.id,
                "name": food.name,
                "kcal": food.kcal,
                "macros": food.macros,
                "category": food.category,
                "tags": food.tags
            }
            for food in available_foods
        ]
        
        # Enhance prompt with trend analysis
        enhanced_prompt = f"""
        Recommend {limit} foods considering:
        
        User: {user_prefs_dict}
        Health: {health_context_dict}
        Recent trends: {trend_analysis.get('trends', [])}
        Concerns: {trend_analysis.get('concerns', [])}
        Strengths: {trend_analysis.get('strengths', [])}
        
        Available foods: {[f"{f['name']} ({f['kcal']}kcal)" for f in available_foods_dict[:15]]}
        
        Return JSON: [{{"food_id": "food_001", "reason": "Addresses low fiber concern", "score": 0.9}}]
        """
        
        response = await ai_service._call_chatgpt(enhanced_prompt, max_tokens=800)
        recommendations = ai_service._parse_recommendations(response)
        
        # Filter to available foods
        food_ids = [food.id for food in available_foods]
        valid_recommendations = [
            rec for rec in recommendations 
            if rec.get("food_id") in food_ids
        ]
        
        return {
            "recommendations": valid_recommendations[:limit],
            "trend_insights": trend_analysis,
            "reasoning": "Based on recent consumption patterns and health context"
        }
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error getting smart recommendations: {str(e)}")

@nutrition_router.get("/cost-optimization/")
async def get_cost_optimization_tips():
    """Get AI-powered cost optimization tips for food choices."""
    try:
        prompt = """
        Provide 5 practical tips for optimizing food costs while maintaining nutrition:
        
        Focus on:
        - Budget-friendly protein sources
        - Seasonal produce
        - Meal prep strategies
        - Smart shopping
        - Waste reduction
        
        Return JSON: {
            "tips": [
                {"category": "protein", "tip": "Use eggs and beans as affordable protein sources", "savings": "$20/week"},
                {"category": "produce", "tip": "Buy seasonal vegetables", "savings": "$15/week"}
            ],
            "total_potential_savings": "$50/week"
        }
        """
        
        response = await ai_service._call_chatgpt(prompt, max_tokens=600)
        
        try:
            import json
            start = response.find('{')
            end = response.rfind('}') + 1
            json_str = response[start:end]
            return json.loads(json_str)
        except:
            return {
                "tips": [
                    {"category": "general", "tip": "Plan meals weekly to reduce waste", "savings": "$10/week"},
                    {"category": "protein", "tip": "Buy protein in bulk and freeze", "savings": "$15/week"}
                ],
                "total_potential_savings": "$25/week"
            }
            
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error getting cost optimization tips: {str(e)}")

@nutrition_router.get("/ai-status/")
async def get_ai_status():
    """Get AI service status and usage statistics."""
    try:
        usage_stats = ai_service.get_usage_stats()
        
        return {
            "status": "active",
            "model": usage_stats.get("model", "gpt-3.5-turbo"),
            "total_tokens": usage_stats.get("total_tokens", 0),
            "total_cost": usage_stats.get("total_cost", 0.0),
            "average_cost_per_request": usage_stats.get("average_cost_per_request", 0.0),
            "features_enabled": [
                "food_recommendations",
                "nutrition_analysis", 
                "meal_planning",
                "trend_analysis",
                "cost_optimization"
            ]
        }
    except Exception as e:
        return {
            "status": "error",
            "error": str(e),
            "features_enabled": []
        }
