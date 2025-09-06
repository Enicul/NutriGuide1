"""
AI Service for ChatGPT API integration with cost optimization
"""
import os
import json
from typing import Dict, List, Optional, Any
from openai import OpenAI
from dotenv import load_dotenv
import logging

# Load environment variables
load_dotenv()

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class AIService:
    def __init__(self):
        api_key = os.getenv("OPENAI_API_KEY")
        if api_key:
            self.client = OpenAI(api_key=api_key)
            self.ai_enabled = True
        else:
            self.client = None
            self.ai_enabled = False
            logger.warning("OpenAI API key not found. AI features will use fallback mode.")
        
        # Cost optimization settings
        self.max_tokens_per_request = 1000  # Limit tokens to control costs
        self.model = "gpt-3.5-turbo"  # Use cheaper model
        self.temperature = 0.7
        
        # Track usage for cost monitoring
        self.total_tokens_used = 0
        self.total_cost = 0.0
        
    def count_tokens(self, text: str) -> int:
        """Count tokens in text for cost estimation (simplified)"""
        # Rough estimation: 1 token ≈ 4 characters for English text
        return len(text) // 4
    
    def estimate_cost(self, prompt_tokens: int, completion_tokens: int) -> float:
        """Estimate cost based on token usage"""
        # GPT-3.5-turbo pricing (as of 2024)
        input_cost_per_1k = 0.0015
        output_cost_per_1k = 0.002
        
        input_cost = (prompt_tokens / 1000) * input_cost_per_1k
        output_cost = (completion_tokens / 1000) * output_cost_per_1k
        
        return input_cost + output_cost
    
    async def get_food_recommendations(
        self, 
        user_prefs: Dict[str, Any], 
        health_context: Dict[str, Any],
        available_foods: List[Dict[str, Any]],
        max_recommendations: int = 5
    ) -> List[Dict[str, Any]]:
        """Get AI-powered food recommendations"""
        
        # Create optimized prompt
        prompt = self._create_recommendation_prompt(
            user_prefs, health_context, available_foods, max_recommendations
        )
        
        try:
            response = await self._call_chatgpt(prompt, max_tokens=800)
            
            # Parse and validate response
            recommendations = self._parse_recommendations(response)
            
            # Filter to available foods only
            food_ids = [food["id"] for food in available_foods]
            valid_recommendations = [
                rec for rec in recommendations 
                if rec.get("food_id") in food_ids
            ]
            
            return valid_recommendations[:max_recommendations]
            
        except Exception as e:
            logger.error(f"Error getting recommendations: {e}")
            return self._fallback_recommendations(available_foods, max_recommendations)
    
    async def analyze_nutrition_balance(
        self, 
        consumed_foods: List[Dict[str, Any]], 
        user_goals: Dict[str, Any]
    ) -> Dict[str, Any]:
        """Analyze nutritional balance and provide insights"""
        
        prompt = self._create_nutrition_analysis_prompt(consumed_foods, user_goals)
        
        try:
            response = await self._call_chatgpt(prompt, max_tokens=600)
            return self._parse_nutrition_analysis(response)
        except Exception as e:
            logger.error(f"Error analyzing nutrition: {e}")
            return self._fallback_nutrition_analysis(consumed_foods)
    
    async def suggest_meal_improvements(
        self, 
        current_meal: Dict[str, Any], 
        user_prefs: Dict[str, Any]
    ) -> Dict[str, Any]:
        """Suggest improvements to current meal"""
        
        prompt = self._create_meal_improvement_prompt(current_meal, user_prefs)
        
        try:
            response = await self._call_chatgpt(prompt, max_tokens=500)
            return self._parse_meal_improvements(response)
        except Exception as e:
            logger.error(f"Error suggesting improvements: {e}")
            return {"suggestions": [], "reasoning": "Unable to analyze meal"}
    
    async def _call_chatgpt(self, prompt: str, max_tokens: int = 1000) -> str:
        """Make API call to ChatGPT with cost optimization"""
        
        if not self.ai_enabled or not self.client:
            raise Exception("AI service not available - no API key provided")
        
        # Truncate prompt if too long
        prompt_tokens = self.count_tokens(prompt)
        if prompt_tokens > 2000:  # Leave room for response
            # Truncate prompt to fit within token limit
            max_prompt_tokens = 2000 - max_tokens
            prompt = self._truncate_text(prompt, max_prompt_tokens)
            prompt_tokens = self.count_tokens(prompt)
        
        try:
            response = self.client.chat.completions.create(
                model=self.model,
                messages=[
                    {"role": "system", "content": "You are a nutrition expert AI assistant. Provide concise, helpful responses."},
                    {"role": "user", "content": prompt}
                ],
                max_tokens=max_tokens,
                temperature=self.temperature
            )
            
            # Track usage
            completion_tokens = response.usage.completion_tokens
            total_tokens = response.usage.total_tokens
            
            self.total_tokens_used += total_tokens
            cost = self.estimate_cost(prompt_tokens, completion_tokens)
            self.total_cost += cost
            
            logger.info(f"API call: {total_tokens} tokens, ${cost:.4f}")
            
            return response.choices[0].message.content
            
        except Exception as e:
            logger.error(f"ChatGPT API error: {e}")
            raise
    
    def _create_recommendation_prompt(
        self, 
        user_prefs: Dict[str, Any], 
        health_context: Dict[str, Any],
        available_foods: List[Dict[str, Any]],
        max_recommendations: int
    ) -> str:
        """Create optimized prompt for food recommendations"""
        
        # Format available foods concisely
        foods_summary = []
        for food in available_foods[:20]:  # Limit to first 20 foods
            foods_summary.append(f"{food['id']}: {food['name']} ({food['kcal']}kcal, {food['macros']['protein_g']}g protein)")
        
        prompt = f"""
        Recommend {max_recommendations} foods based on:
        
        User: {user_prefs.get('diet_style', 'omnivore')} diet, budget {user_prefs.get('budget', '$$')}, dislikes: {user_prefs.get('dislikes', [])}
        Health: {health_context.get('sleep_hours', 8)}h sleep, {health_context.get('activity_level', 'moderate')} activity, {health_context.get('mood', 'normal')} mood
        
        Available foods:
        {chr(10).join(foods_summary)}
        
        Return JSON: [{{"food_id": "food_001", "reason": "High protein for recovery", "score": 0.9}}]
        """
        
        return prompt
    
    def _create_nutrition_analysis_prompt(
        self, 
        consumed_foods: List[Dict[str, Any]], 
        user_goals: Dict[str, Any]
    ) -> str:
        """Create prompt for nutrition analysis"""
        
        # Calculate totals
        total_calories = sum(food.get('kcal', 0) for food in consumed_foods)
        total_protein = sum(food.get('macros', {}).get('protein_g', 0) for food in consumed_foods)
        total_carbs = sum(food.get('macros', {}).get('carbs_g', 0) for food in consumed_foods)
        total_fat = sum(food.get('macros', {}).get('fat_g', 0) for food in consumed_foods)
        
        prompt = f"""
        Analyze nutrition for these foods (total: {total_calories} kcal, {total_protein}g protein, {total_carbs}g carbs, {total_fat}g fat):
        
        {[food['name'] for food in consumed_foods]}
        
        User goals: {user_goals}
        
        Return JSON: {{"balance_score": 0.8, "strengths": ["high protein"], "improvements": ["add vegetables"], "next_meal_suggestions": ["salad"]}}
        """
        
        return prompt
    
    def _create_meal_improvement_prompt(
        self, 
        current_meal: Dict[str, Any], 
        user_prefs: Dict[str, Any]
    ) -> str:
        """Create prompt for meal improvement suggestions"""
        
        prompt = f"""
        Suggest improvements for this meal: {current_meal.get('name', 'Unknown')}
        Nutrition: {current_meal.get('macros', {})}
        
        User preferences: {user_prefs}
        
        Return JSON: {{"suggestions": ["add vegetables", "reduce sodium"], "reasoning": "Meal lacks fiber and has high sodium"}}
        """
        
        return prompt
    
    def _parse_recommendations(self, response: str) -> List[Dict[str, Any]]:
        """Parse ChatGPT response into recommendation format"""
        try:
            # Extract JSON from response
            start = response.find('[')
            end = response.rfind(']') + 1
            json_str = response[start:end]
            
            recommendations = json.loads(json_str)
            return recommendations if isinstance(recommendations, list) else []
            
        except (json.JSONDecodeError, ValueError) as e:
            logger.error(f"Error parsing recommendations: {e}")
            return []
    
    def _parse_nutrition_analysis(self, response: str) -> Dict[str, Any]:
        """Parse nutrition analysis response"""
        try:
            start = response.find('{')
            end = response.rfind('}') + 1
            json_str = response[start:end]
            
            return json.loads(json_str)
        except (json.JSONDecodeError, ValueError) as e:
            logger.error(f"Error parsing nutrition analysis: {e}")
            return {"balance_score": 0.5, "strengths": [], "improvements": []}
    
    def _parse_meal_improvements(self, response: str) -> Dict[str, Any]:
        """Parse meal improvement suggestions"""
        try:
            start = response.find('{')
            end = response.rfind('}') + 1
            json_str = response[start:end]
            
            return json.loads(json_str)
        except (json.JSONDecodeError, ValueError) as e:
            logger.error(f"Error parsing meal improvements: {e}")
            return {"suggestions": [], "reasoning": "Unable to analyze"}
    
    def _truncate_text(self, text: str, max_tokens: int) -> str:
        """Truncate text to fit within token limit"""
        # Rough estimation: 1 token ≈ 4 characters
        max_chars = max_tokens * 4
        if len(text) <= max_chars:
            return text
        
        return text[:max_chars] + "..."
    
    def _fallback_recommendations(self, available_foods: List[Dict[str, Any]], max_recommendations: int) -> List[Dict[str, Any]]:
        """Fallback recommendations when AI fails"""
        return [
            {
                "food_id": food["id"],
                "reason": "Balanced nutrition",
                "score": 0.7
            }
            for food in available_foods[:max_recommendations]
        ]
    
    def _fallback_nutrition_analysis(self, consumed_foods: List[Dict[str, Any]]) -> Dict[str, Any]:
        """Fallback nutrition analysis when AI fails"""
        total_calories = sum(food.get('kcal', 0) for food in consumed_foods)
        return {
            "balance_score": 0.6,
            "strengths": ["adequate calories"] if total_calories > 0 else [],
            "improvements": ["add variety"],
            "next_meal_suggestions": ["balanced meal"]
        }
    
    def get_usage_stats(self) -> Dict[str, Any]:
        """Get API usage statistics"""
        return {
            "ai_enabled": self.ai_enabled,
            "total_tokens": self.total_tokens_used,
            "total_cost": round(self.total_cost, 4),
            "model": self.model if self.ai_enabled else "none",
            "average_cost_per_request": round(self.total_cost / max(1, self.total_tokens_used / 1000), 4) if self.total_tokens_used > 0 else 0
        }

# Global instance
ai_service = AIService()
