"""
AI-Powered Nutrition Engine using ChatGPT API
"""
from typing import Dict, List, Any, Optional
from datetime import datetime, timedelta
import logging
from .ai_service import ai_service

logger = logging.getLogger(__name__)

class NutritionEngine:
    def __init__(self):
        self.ai_service = ai_service
        
    async def calculate_daily_nutrition_goals(
        self, 
        user_profile: Dict[str, Any],
        health_context: Dict[str, Any]
    ) -> Dict[str, Any]:
        """Calculate personalized daily nutrition goals using AI"""
        
        prompt = f"""
        Calculate daily nutrition goals for:
        - Age: {user_profile.get('age', 30)}
        - Weight: {user_profile.get('weight', 70)}kg
        - Height: {user_profile.get('height', 170)}cm
        - Activity: {health_context.get('activity_level', 'moderate')}
        - Sleep: {health_context.get('sleep_hours', 8)} hours
        - Goals: {user_profile.get('goals', 'maintain')}
        
        Return JSON: {{
            "calories": 2000,
            "protein_g": 150,
            "carbs_g": 250,
            "fat_g": 67,
            "fiber_g": 25,
            "reasoning": "Based on moderate activity and maintenance goals"
        }}
        """
        
        try:
            response = await self.ai_service._call_chatgpt(prompt, max_tokens=400)
            return self._parse_nutrition_goals(response)
        except Exception as e:
            logger.error(f"Error calculating nutrition goals: {e}")
            return self._fallback_nutrition_goals(user_profile, health_context)
    
    async def analyze_meal_balance(
        self, 
        meal_foods: List[Dict[str, Any]], 
        daily_goals: Dict[str, Any],
        meal_type: str = "lunch"
    ) -> Dict[str, Any]:
        """Analyze if meal is balanced and suggest improvements"""
        
        # Calculate meal totals
        meal_totals = self._calculate_meal_totals(meal_foods)
        
        prompt = f"""
        Analyze this {meal_type} meal balance:
        
        Meal totals: {meal_totals}
        Daily goals: {daily_goals}
        
        Consider:
        - Macronutrient ratios
        - Meal timing appropriateness
        - Satiety factors
        - Nutrient density
        
        Return JSON: {{
            "balance_score": 0.8,
            "strengths": ["good protein", "adequate calories"],
            "weaknesses": ["low fiber", "high sodium"],
            "suggestions": ["add vegetables", "choose whole grains"],
            "next_meal_focus": "fiber and micronutrients"
        }}
        """
        
        try:
            response = await self.ai_service._call_chatgpt(prompt, max_tokens=500)
            return self._parse_meal_analysis(response)
        except Exception as e:
            logger.error(f"Error analyzing meal balance: {e}")
            return self._fallback_meal_analysis(meal_totals, daily_goals)
    
    async def suggest_food_swaps(
        self, 
        current_food: Dict[str, Any], 
        user_prefs: Dict[str, Any],
        available_foods: List[Dict[str, Any]]
    ) -> List[Dict[str, Any]]:
        """Suggest healthier food swaps using AI"""
        
        prompt = f"""
        Suggest 3 healthier alternatives to: {current_food['name']}
        
        Current nutrition: {current_food.get('macros', {})} - {current_food.get('kcal', 0)} kcal
        
        User preferences: {user_prefs}
        
        Available alternatives: {[f"{f['name']} ({f['kcal']}kcal)" for f in available_foods[:10]]}
        
        Return JSON: [
            {{
                "food_id": "food_002",
                "name": "Grilled Chicken Salad",
                "improvement": "Lower calories, higher protein",
                "nutrition_gain": "More fiber, less sodium"
            }}
        ]
        """
        
        try:
            response = await self.ai_service._call_chatgpt(prompt, max_tokens=600)
            return self._parse_food_swaps(response)
        except Exception as e:
            logger.error(f"Error suggesting food swaps: {e}")
            return []
    
    async def generate_meal_plan(
        self, 
        user_prefs: Dict[str, Any],
        health_context: Dict[str, Any],
        available_foods: List[Dict[str, Any]],
        days: int = 3
    ) -> Dict[str, Any]:
        """Generate AI-powered meal plan"""
        
        prompt = f"""
        Create a {days}-day meal plan:
        
        User: {user_prefs.get('diet_style', 'omnivore')}, budget {user_prefs.get('budget', '$$')}
        Health: {health_context.get('activity_level', 'moderate')} activity, {health_context.get('sleep_hours', 8)}h sleep
        Available foods: {[f"{f['name']} ({f['kcal']}kcal)" for f in available_foods[:15]]}
        
        Return JSON: {{
            "day_1": {{
                "breakfast": {{"food_id": "food_001", "reason": "High protein start"}},
                "lunch": {{"food_id": "food_002", "reason": "Balanced nutrition"}},
                "dinner": {{"food_id": "food_003", "reason": "Light and healthy"}}
            }},
            "day_2": {{...}},
            "day_3": {{...}},
            "shopping_list": ["ingredient1", "ingredient2"],
            "total_weekly_cost": "$45"
        }}
        """
        
        try:
            response = await self.ai_service._call_chatgpt(prompt, max_tokens=1000)
            return self._parse_meal_plan(response)
        except Exception as e:
            logger.error(f"Error generating meal plan: {e}")
            return self._fallback_meal_plan(available_foods, days)
    
    async def analyze_nutrition_trends(
        self, 
        consumption_logs: List[Dict[str, Any]],
        time_period: str = "week"
    ) -> Dict[str, Any]:
        """Analyze nutrition trends over time using AI"""
        
        # Calculate period totals
        period_totals = self._calculate_period_totals(consumption_logs)
        
        prompt = f"""
        Analyze nutrition trends over the past {time_period}:
        
        Totals: {period_totals}
        
        Look for:
        - Consistent patterns
        - Nutrient deficiencies
        - Overconsumption areas
        - Meal timing patterns
        - Variety in food choices
        
        Return JSON: {{
            "trends": ["increasing protein", "decreasing variety"],
            "concerns": ["low fiber intake", "high sodium"],
            "strengths": ["consistent meal timing", "good protein"],
            "recommendations": ["add more vegetables", "reduce processed foods"],
            "score": 0.7
        }}
        """
        
        try:
            response = await self.ai_service._call_chatgpt(prompt, max_tokens=600)
            return self._parse_trend_analysis(response)
        except Exception as e:
            logger.error(f"Error analyzing trends: {e}")
            return self._fallback_trend_analysis(period_totals)
    
    def _calculate_meal_totals(self, meal_foods: List[Dict[str, Any]]) -> Dict[str, Any]:
        """Calculate total nutrition for a meal"""
        totals = {
            "calories": 0,
            "protein_g": 0,
            "carbs_g": 0,
            "fat_g": 0,
            "fiber_g": 0,
            "sodium_mg": 0
        }
        
        for food in meal_foods:
            # Handle both direct kcal and nested kcal
            if "kcal" in food:
                totals["calories"] += food.get("kcal", 0)
            elif "macros" in food and "kcal" in food["macros"]:
                totals["calories"] += food["macros"].get("kcal", 0)
            
            # Handle macros as either dict or Pydantic model
            macros = food.get("macros", {})
            if hasattr(macros, 'protein_g'):
                # Pydantic model
                totals["protein_g"] += getattr(macros, 'protein_g', 0)
                totals["carbs_g"] += getattr(macros, 'carbs_g', 0)
                totals["fat_g"] += getattr(macros, 'fat_g', 0)
                totals["fiber_g"] += getattr(macros, 'fiber_g', 0)
                totals["sodium_mg"] += getattr(macros, 'sodium_mg', 0)
            else:
                # Dictionary
                totals["protein_g"] += macros.get("protein_g", 0)
                totals["carbs_g"] += macros.get("carbs_g", 0)
                totals["fat_g"] += macros.get("fat_g", 0)
                totals["fiber_g"] += macros.get("fiber_g", 0)
                totals["sodium_mg"] += macros.get("sodium_mg", 0)
        
        return totals
    
    def _calculate_period_totals(self, logs: List[Dict[str, Any]]) -> Dict[str, Any]:
        """Calculate nutrition totals for a time period"""
        period_totals = {
            "total_calories": 0,
            "avg_daily_calories": 0,
            "total_protein": 0,
            "total_carbs": 0,
            "total_fat": 0,
            "days_logged": len(set(log.get("date") for log in logs)),
            "meals_logged": len(logs)
        }
        
        for log in logs:
            food = log.get("food", {})
            period_totals["total_calories"] += food.get("kcal", 0)
            macros = food.get("macros", {})
            period_totals["total_protein"] += macros.get("protein_g", 0)
            period_totals["total_carbs"] += macros.get("carbs_g", 0)
            period_totals["total_fat"] += macros.get("fat_g", 0)
        
        if period_totals["days_logged"] > 0:
            period_totals["avg_daily_calories"] = period_totals["total_calories"] / period_totals["days_logged"]
        
        return period_totals
    
    def _parse_nutrition_goals(self, response: str) -> Dict[str, Any]:
        """Parse nutrition goals response"""
        try:
            import json
            start = response.find('{')
            end = response.rfind('}') + 1
            json_str = response[start:end]
            return json.loads(json_str)
        except Exception as e:
            logger.error(f"Error parsing nutrition goals: {e}")
            return self._fallback_nutrition_goals({}, {})
    
    def _parse_meal_analysis(self, response: str) -> Dict[str, Any]:
        """Parse meal analysis response"""
        try:
            import json
            start = response.find('{')
            end = response.rfind('}') + 1
            json_str = response[start:end]
            return json.loads(json_str)
        except Exception as e:
            logger.error(f"Error parsing meal analysis: {e}")
            return {"balance_score": 0.5, "strengths": [], "weaknesses": [], "suggestions": []}
    
    def _parse_food_swaps(self, response: str) -> List[Dict[str, Any]]:
        """Parse food swap suggestions"""
        try:
            import json
            start = response.find('[')
            end = response.rfind(']') + 1
            json_str = response[start:end]
            return json.loads(json_str)
        except Exception as e:
            logger.error(f"Error parsing food swaps: {e}")
            return []
    
    def _parse_meal_plan(self, response: str) -> Dict[str, Any]:
        """Parse meal plan response"""
        try:
            import json
            start = response.find('{')
            end = response.rfind('}') + 1
            json_str = response[start:end]
            return json.loads(json_str)
        except Exception as e:
            logger.error(f"Error parsing meal plan: {e}")
            return self._fallback_meal_plan([], 3)
    
    def _parse_trend_analysis(self, response: str) -> Dict[str, Any]:
        """Parse trend analysis response"""
        try:
            import json
            start = response.find('{')
            end = response.rfind('}') + 1
            json_str = response[start:end]
            return json.loads(json_str)
        except Exception as e:
            logger.error(f"Error parsing trend analysis: {e}")
            return {"trends": [], "concerns": [], "strengths": [], "recommendations": [], "score": 0.5}
    
    def _fallback_nutrition_goals(self, user_profile: Dict[str, Any], health_context: Dict[str, Any]) -> Dict[str, Any]:
        """Fallback nutrition goals calculation"""
        # Basic BMR calculation
        weight = user_profile.get('weight', 70)
        height = user_profile.get('height', 170)
        age = user_profile.get('age', 30)
        
        # Mifflin-St Jeor Equation
        bmr = 10 * weight + 6.25 * height - 5 * age + 5
        
        # Activity multiplier
        activity_multiplier = {
            'none': 1.2,
            'light': 1.375,
            'moderate': 1.55,
            'intense': 1.725
        }.get(health_context.get('activity_level', 'moderate'), 1.55)
        
        calories = int(bmr * activity_multiplier)
        
        return {
            "calories": calories,
            "protein_g": int(calories * 0.25 / 4),  # 25% of calories from protein
            "carbs_g": int(calories * 0.45 / 4),   # 45% of calories from carbs
            "fat_g": int(calories * 0.30 / 9),     # 30% of calories from fat
            "fiber_g": 25,
            "reasoning": "Basic calculation based on BMR and activity level"
        }
    
    def _fallback_meal_analysis(self, meal_totals: Dict[str, Any], daily_goals: Dict[str, Any]) -> Dict[str, Any]:
        """Fallback meal analysis"""
        calories = meal_totals.get("calories", 0)
        protein = meal_totals.get("protein_g", 0)
        
        # Simple scoring
        calorie_score = min(1.0, calories / (daily_goals.get("calories", 2000) * 0.3))  # 30% of daily calories
        protein_score = min(1.0, protein / 20)  # 20g protein per meal
        
        balance_score = (calorie_score + protein_score) / 2
        
        return {
            "balance_score": balance_score,
            "strengths": ["adequate calories"] if calories > 300 else [],
            "weaknesses": ["low protein"] if protein < 15 else [],
            "suggestions": ["add protein"] if protein < 15 else [],
            "next_meal_focus": "balance"
        }
    
    def _fallback_meal_plan(self, available_foods: List[Dict[str, Any]], days: int) -> Dict[str, Any]:
        """Fallback meal plan"""
        plan = {}
        for day in range(1, days + 1):
            plan[f"day_{day}"] = {
                "breakfast": {"food_id": available_foods[0]["id"] if available_foods else "none", "reason": "Available option"},
                "lunch": {"food_id": available_foods[1]["id"] if len(available_foods) > 1 else "none", "reason": "Available option"},
                "dinner": {"food_id": available_foods[2]["id"] if len(available_foods) > 2 else "none", "reason": "Available option"}
            }
        
        return {
            **plan,
            "shopping_list": ["basic ingredients"],
            "total_weekly_cost": "$30"
        }
    
    def _fallback_trend_analysis(self, period_totals: Dict[str, Any]) -> Dict[str, Any]:
        """Fallback trend analysis"""
        avg_calories = period_totals.get("avg_daily_calories", 0)
        
        return {
            "trends": ["consistent logging"] if period_totals.get("days_logged", 0) > 3 else [],
            "concerns": ["low calories"] if avg_calories < 1200 else [],
            "strengths": ["regular logging"] if period_totals.get("meals_logged", 0) > 5 else [],
            "recommendations": ["maintain current habits"],
            "score": 0.6
        }

# Global instance
nutrition_engine = NutritionEngine()
