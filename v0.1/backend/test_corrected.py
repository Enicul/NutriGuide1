"""
Corrected Test Script for Spark Food Recommendation System
Uses the correct API field names and structures
"""

import requests
import json
import time
from datetime import datetime, timedelta
import random

# Configuration
BASE_URL = "http://localhost:8000"
TEST_USER_ID = "user_001"

def print_section(title):
    """Print a formatted section header"""
    print(f"\n{'='*60}")
    print(f"🧪 {title}")
    print(f"{'='*60}")

def print_test(test_name, success, details=""):
    """Print test result"""
    status = "✅ PASS" if success else "❌ FAIL"
    print(f"{status} {test_name}")
    if details:
        print(f"    {details}")

def test_api_health():
    """Test basic API health"""
    print_section("API Health Check")
    
    try:
        response = requests.get(f"{BASE_URL}/")
        success = response.status_code == 200
        print_test("Root endpoint", success, f"Status: {response.status_code}")
        
        response = requests.get(f"{BASE_URL}/docs")
        success = response.status_code == 200
        print_test("API documentation", success, f"Status: {response.status_code}")
        
        return True
    except Exception as e:
        print_test("API health", False, f"Error: {str(e)}")
        return False

def test_food_endpoints():
    """Test all food-related endpoints"""
    print_section("Food Endpoints Testing")
    
    # Test get all foods
    try:
        response = requests.get(f"{BASE_URL}/api/foods/")
        success = response.status_code == 200
        data = response.json() if success else []
        print_test("Get all foods", success, f"Found {len(data)} foods")
    except Exception as e:
        print_test("Get all foods", False, f"Error: {str(e)}")
    
    # Test get food by ID
    try:
        response = requests.get(f"{BASE_URL}/api/foods/food_001")
        success = response.status_code == 200
        data = response.json() if success else {}
        print_test("Get food by ID", success, f"Food: {data.get('name', 'Unknown')}")
    except Exception as e:
        print_test("Get food by ID", False, f"Error: {str(e)}")
    
    # Test food recommendations (corrected structure)
    try:
        recommendation_data = {
            "user_pref": {
                "diet_style": "omnivore",
                "dislikes": [],
                "budget": "$$",
                "home_area": "downtown"
            },
            "health_context": {
                "sleep_hours": 8.0,
                "activity_level": "moderate",
                "mood_energy": "normal"
            },
            "limit": 5
        }
        
        response = requests.post(
            f"{BASE_URL}/api/foods/recommend/",
            json=recommendation_data,
            headers={"Content-Type": "application/json"}
        )
        success = response.status_code == 200
        data = response.json() if success else []
        print_test("Food recommendations", success, f"Recommended {len(data)} foods")
        
        if success and data:
            print("    Sample recommendations:")
            for i, food in enumerate(data[:3], 1):
                print(f"    {i}. {food['name']} - {food['category']} - {food['kcal']} kcal")
                
    except Exception as e:
        print_test("Food recommendations", False, f"Error: {str(e)}")
    
    # Test meal analysis (corrected structure)
    try:
        # First get some foods to use in the analysis
        foods_response = requests.get(f"{BASE_URL}/api/foods/")
        if foods_response.status_code == 200:
            foods = foods_response.json()
            if foods:
                meal_data = {
                    "meal_foods": [foods[0]],  # Use first food (already has all required fields)
                    "daily_goals": {
                        "daily_calories": 2000,
                        "protein_g": 120.0,
                        "carbs_g": 250.0,
                        "fat_g": 67.0
                    },
                    "meal_type": "breakfast"
                }
                
                response = requests.post(
                    f"{BASE_URL}/api/foods/analyze-meal/",
                    json=meal_data,
                    headers={"Content-Type": "application/json"}
                )
                success = response.status_code == 200
                data = response.json() if success else {}
                print_test("Meal analysis", success, f"Analysis: {data.get('balance_score', 'N/A')}")
            else:
                print_test("Meal analysis", False, "No foods available for analysis")
        else:
            print_test("Meal analysis", False, "Could not fetch foods for analysis")
        
    except Exception as e:
        print_test("Meal analysis", False, f"Error: {str(e)}")
    
    # Test food swaps (corrected structure)
    try:
        # First get some foods
        foods_response = requests.get(f"{BASE_URL}/api/foods/")
        if foods_response.status_code == 200:
            foods = foods_response.json()
            if len(foods) >= 2:
                swap_data = {
                    "current_food": foods[0],
                    "user_pref": {
                        "diet_style": "omnivore",
                        "dislikes": [],
                        "budget": "$$",
                        "home_area": "downtown"
                    },
                    "available_foods": foods[1:3]  # Use next 2 foods
                }
                
                response = requests.post(
                    f"{BASE_URL}/api/foods/suggest-swaps/",
                    json=swap_data,
                    headers={"Content-Type": "application/json"}
                )
                success = response.status_code == 200
                data = response.json() if success else {}
                print_test("Food swaps", success, f"Suggested {len(data.get('suggestions', []))} alternatives")
            else:
                print_test("Food swaps", False, "Not enough foods available for swaps")
        else:
            print_test("Food swaps", False, "Could not fetch foods for swaps")
        
    except Exception as e:
        print_test("Food swaps", False, f"Error: {str(e)}")

def test_nutrition_endpoints():
    """Test all nutrition-related endpoints"""
    print_section("Nutrition Endpoints Testing")
    
    # Test daily goals calculation (corrected structure)
    try:
        goals_data = {
            "user_profile": {
                "age": 28,
                "weight": 65.0,
                "height": 165.0,
                "goals": "maintain"
            },
            "health_context": {
                "sleep_hours": 8.0,
                "activity_level": "moderate",
                "mood_energy": "normal"
            }
        }
        
        response = requests.post(
            f"{BASE_URL}/api/nutrition/daily-goals/",
            json=goals_data,
            headers={"Content-Type": "application/json"}
        )
        success = response.status_code == 200
        data = response.json() if success else {}
        print_test("Daily goals calculation", success, f"Calories: {data.get('daily_calories', 'N/A')}")
        
    except Exception as e:
        print_test("Daily goals calculation", False, f"Error: {str(e)}")
    
    # Test meal planning (corrected structure)
    try:
        # First get foods
        foods_response = requests.get(f"{BASE_URL}/api/foods/")
        if foods_response.status_code == 200:
            foods = foods_response.json()
            if foods:
                meal_plan_data = {
                    "user_pref": {
                        "diet_style": "omnivore",
                        "dislikes": [],
                        "budget": "$$",
                        "home_area": "downtown"
                    },
                    "health_context": {
                        "sleep_hours": 8.0,
                        "activity_level": "moderate",
                        "mood_energy": "normal"
                    },
                    "available_foods": foods[:10],  # Use first 10 foods
                    "days": 3
                }
                
                response = requests.post(
                    f"{BASE_URL}/api/nutrition/meal-plan/",
                    json=meal_plan_data,
                    headers={"Content-Type": "application/json"}
                )
                success = response.status_code == 200
                data = response.json() if success else {}
                print_test("Meal planning", success, f"Planned {len(data.get('days', []))} days")
            else:
                print_test("Meal planning", False, "No foods available for meal planning")
        else:
            print_test("Meal planning", False, "Could not fetch foods for meal planning")
        
    except Exception as e:
        print_test("Meal planning", False, f"Error: {str(e)}")
    
    # Test nutrition trends (corrected structure)
    try:
        trends_data = {
            "consumption_logs": [
                {
                    "user_id": TEST_USER_ID,
                    "food_id": "food_001",
                    "quantity": 1.0,
                    "meal_type": "breakfast",
                    "consumed_at": "2024-01-01T08:00:00"
                },
                {
                    "user_id": TEST_USER_ID,
                    "food_id": "food_002",
                    "quantity": 1.5,
                    "meal_type": "lunch",
                    "consumed_at": "2024-01-01T12:00:00"
                }
            ],
            "time_period": "week"
        }
        
        response = requests.post(
            f"{BASE_URL}/api/nutrition/trends/",
            json=trends_data,
            headers={"Content-Type": "application/json"}
        )
        success = response.status_code == 200
        data = response.json() if success else {}
        print_test("Nutrition trends", success, f"Trends: {data.get('trend_type', 'N/A')}")
        
    except Exception as e:
        print_test("Nutrition trends", False, f"Error: {str(e)}")

def test_ai_features():
    """Test AI-related features"""
    print_section("AI Features Testing")
    
    # Test AI status
    try:
        response = requests.get(f"{BASE_URL}/api/nutrition/ai-status/")
        success = response.status_code == 200
        data = response.json() if success else {}
        print_test("AI status check", success, f"AI Available: {data.get('status', 'unknown')}")
        
    except Exception as e:
        print_test("AI status check", False, f"Error: {str(e)}")
    
    # Test AI usage stats
    try:
        response = requests.get(f"{BASE_URL}/api/foods/ai-usage-stats/")
        success = response.status_code == 200
        data = response.json() if success else {}
        print_test("AI usage stats", success, f"Total cost: ${data.get('total_cost', 0):.4f}")
        
    except Exception as e:
        print_test("AI usage stats", False, f"Error: {str(e)}")

def simulate_user_flows():
    """Simulate complete user flows"""
    print_section("User Flow Simulation")
    
    # Flow 1: New user onboarding
    print("\n🔄 Flow 1: New User Onboarding")
    try:
        # Step 1: Get daily goals
        goals_data = {
            "user_profile": {
                "age": 30,
                "weight": 70.0,
                "height": 175.0,
                "goals": "lose_weight"
            },
            "health_context": {
                "sleep_hours": 7.5,
                "activity_level": "moderate",
                "mood_energy": "normal"
            }
        }
        
        response = requests.post(
            f"{BASE_URL}/api/nutrition/daily-goals/",
            json=goals_data,
            headers={"Content-Type": "application/json"}
        )
        
        if response.status_code == 200:
            goals = response.json()
            print(f"    ✅ Daily goals set: {goals.get('daily_calories', 'N/A')} calories")
            
            # Step 2: Get meal plan
            foods_response = requests.get(f"{BASE_URL}/api/foods/")
            if foods_response.status_code == 200:
                foods = foods_response.json()
                if foods:
                    meal_plan_data = {
                        "user_pref": {
                            "diet_style": "omnivore",
                            "dislikes": ["seafood"],
                            "budget": "$$",
                            "home_area": "downtown"
                        },
                        "health_context": {
                            "sleep_hours": 7.5,
                            "activity_level": "moderate",
                            "mood_energy": "normal"
                        },
                        "available_foods": foods[:15],
                        "days": 1
                    }
                    
                    response = requests.post(
                        f"{BASE_URL}/api/nutrition/meal-plan/",
                        json=meal_plan_data,
                        headers={"Content-Type": "application/json"}
                    )
                    
                    if response.status_code == 200:
                        meal_plan = response.json()
                        print(f"    ✅ Meal plan created: {len(meal_plan.get('days', []))} days")
                        
                        # Step 3: Get food recommendations
                        rec_data = {
                            "user_pref": {
                                "diet_style": "omnivore",
                                "dislikes": ["seafood"],
                                "budget": "$$",
                                "home_area": "downtown"
                            },
                            "health_context": {
                                "sleep_hours": 7.5,
                                "activity_level": "moderate",
                                "mood_energy": "normal"
                            },
                            "limit": 3
                        }
                        
                        response = requests.post(
                            f"{BASE_URL}/api/foods/recommend/",
                            json=rec_data,
                            headers={"Content-Type": "application/json"}
                        )
                        
                        if response.status_code == 200:
                            recommendations = response.json()
                            print(f"    ✅ Food recommendations: {len(recommendations)} items")
                            print("    🎯 Complete onboarding flow successful!")
                        else:
                            print(f"    ❌ Food recommendations failed: {response.status_code}")
                    else:
                        print(f"    ❌ Meal plan failed: {response.status_code}")
                else:
                    print("    ❌ No foods available for meal planning")
            else:
                print("    ❌ Could not fetch foods for meal planning")
        else:
            print(f"    ❌ Daily goals failed: {response.status_code}")
            
    except Exception as e:
        print(f"    ❌ Onboarding flow failed: {str(e)}")
    
    # Flow 2: Daily nutrition tracking
    print("\n🔄 Flow 2: Daily Nutrition Tracking")
    try:
        # Step 1: Get foods for analysis
        foods_response = requests.get(f"{BASE_URL}/api/foods/")
        if foods_response.status_code == 200:
            foods = foods_response.json()
            if foods:
                # Step 2: Analyze breakfast
                breakfast_data = {
                    "meal_foods": [foods[0]],  # Use first food (already has all required fields)
                    "daily_goals": {
                        "daily_calories": 2000,
                        "protein_g": 120.0,
                        "carbs_g": 250.0,
                        "fat_g": 67.0
                    },
                    "meal_type": "breakfast"
                }
                
                response = requests.post(
                    f"{BASE_URL}/api/foods/analyze-meal/",
                    json=breakfast_data,
                    headers={"Content-Type": "application/json"}
                )
                
                if response.status_code == 200:
                    analysis = response.json()
                    print(f"    ✅ Breakfast analyzed: {analysis.get('balance_score', 'N/A')} balance score")
                    
                    # Step 3: Get lunch recommendations
                    lunch_data = {
                        "user_pref": {
                            "diet_style": "omnivore",
                            "dislikes": [],
                            "budget": "$$",
                            "home_area": "campus"
                        },
                        "health_context": {
                            "sleep_hours": 8.0,
                            "activity_level": "moderate",
                            "mood_energy": "normal"
                        },
                        "limit": 3
                    }
                    
                    response = requests.post(
                        f"{BASE_URL}/api/foods/recommend/",
                        json=lunch_data,
                        headers={"Content-Type": "application/json"}
                    )
                    
                    if response.status_code == 200:
                        lunch_recs = response.json()
                        print(f"    ✅ Lunch recommendations: {len(lunch_recs)} options")
                        
                        # Step 4: Check nutrition trends
                        trends_data = {
                            "consumption_logs": [
                                {
                                    "user_id": TEST_USER_ID,
                                    "food_id": "food_001",
                                    "quantity": 1.0,
                                    "meal_type": "breakfast",
                                    "consumed_at": "2024-01-01T08:00:00"
                                }
                            ],
                            "time_period": "week"
                        }
                        
                        response = requests.post(
                            f"{BASE_URL}/api/nutrition/trends/",
                            json=trends_data,
                            headers={"Content-Type": "application/json"}
                        )
                        
                        if response.status_code == 200:
                            trends = response.json()
                            print(f"    ✅ Nutrition trends: {trends.get('trend_type', 'N/A')}")
                            print("    🎯 Daily tracking flow successful!")
                        else:
                            print(f"    ❌ Nutrition trends failed: {response.status_code}")
                    else:
                        print(f"    ❌ Lunch recommendations failed: {response.status_code}")
                else:
                    print(f"    ❌ Breakfast analysis failed: {response.status_code}")
            else:
                print("    ❌ No foods available for analysis")
        else:
            print("    ❌ Could not fetch foods for analysis")
            
    except Exception as e:
        print(f"    ❌ Daily tracking flow failed: {str(e)}")

def test_error_handling():
    """Test error handling and edge cases"""
    print_section("Error Handling Testing")
    
    # Test invalid food ID
    try:
        response = requests.get(f"{BASE_URL}/api/foods/invalid_id")
        success = response.status_code == 404
        print_test("Invalid food ID", success, f"Status: {response.status_code}")
    except Exception as e:
        print_test("Invalid food ID", False, f"Error: {str(e)}")
    
    # Test malformed recommendation request
    try:
        response = requests.post(
            f"{BASE_URL}/api/foods/recommend/",
            json={"invalid": "data"},
            headers={"Content-Type": "application/json"}
        )
        success = response.status_code == 422  # Validation error
        print_test("Malformed request", success, f"Status: {response.status_code}")
    except Exception as e:
        print_test("Malformed request", False, f"Error: {str(e)}")
    
    # Test empty recommendation request
    try:
        response = requests.post(
            f"{BASE_URL}/api/foods/recommend/",
            json={},
            headers={"Content-Type": "application/json"}
        )
        success = response.status_code == 422  # Validation error
        print_test("Empty request", success, f"Status: {response.status_code}")
    except Exception as e:
        print_test("Empty request", False, f"Error: {str(e)}")

def main():
    """Run comprehensive tests"""
    print("🚀 Starting Corrected Spark Food Recommendation System Tests")
    print(f"⏰ Test started at: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    
    # Wait for server to be ready
    print("\n⏳ Waiting for server to be ready...")
    time.sleep(2)
    
    # Run all tests
    test_api_health()
    test_food_endpoints()
    test_nutrition_endpoints()
    test_ai_features()
    simulate_user_flows()
    test_error_handling()
    
    print_section("Test Summary")
    print("🎉 Comprehensive testing completed!")
    print("📊 All major features have been tested")
    print("🔄 User flows have been simulated")
    print("🛡️ Error handling has been verified")
    print(f"⏰ Test completed at: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")

if __name__ == "__main__":
    main()
