"""
Test Data Generator for Spark Food Recommendation System
Creates realistic test data for comprehensive testing
"""

import sqlite3
import json
from datetime import datetime, timedelta
import random

def create_test_database():
    """Create a comprehensive test database with realistic data"""
    
    # Connect to test database
    conn = sqlite3.connect('test_spark.db')
    cursor = conn.cursor()
    
    # Create tables
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS foods (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            category TEXT NOT NULL,
            tags TEXT NOT NULL,
            macros TEXT NOT NULL,
            kcal INTEGER NOT NULL,
            availability TEXT NOT NULL,
            est_price_range TEXT NOT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    ''')
    
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS users (
            id TEXT PRIMARY KEY,
            username TEXT UNIQUE NOT NULL,
            email TEXT UNIQUE NOT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    ''')
    
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS user_preferences (
            user_id TEXT PRIMARY KEY,
            diet_style TEXT NOT NULL,
            dislikes TEXT NOT NULL,
            budget TEXT NOT NULL,
            home_area TEXT,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (user_id) REFERENCES users (id)
        )
    ''')
    
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS health_contexts (
            user_id TEXT PRIMARY KEY,
            sleep_hours REAL NOT NULL,
            activity_level TEXT NOT NULL,
            mood_energy TEXT NOT NULL,
            weight_kg REAL,
            height_cm REAL,
            age INTEGER,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (user_id) REFERENCES users (id)
        )
    ''')
    
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS consumption_logs (
            id TEXT PRIMARY KEY,
            user_id TEXT NOT NULL,
            food_id TEXT NOT NULL,
            quantity REAL NOT NULL,
            meal_type TEXT NOT NULL,
            consumed_at TIMESTAMP NOT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (user_id) REFERENCES users (id),
            FOREIGN KEY (food_id) REFERENCES foods (id)
        )
    ''')
    
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS nutrition_goals (
            id TEXT PRIMARY KEY,
            user_id TEXT NOT NULL,
            daily_calories INTEGER NOT NULL,
            protein_g REAL NOT NULL,
            carbs_g REAL NOT NULL,
            fat_g REAL NOT NULL,
            fiber_g REAL NOT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (user_id) REFERENCES users (id)
        )
    ''')
    
    # Insert comprehensive food data
    foods_data = [
        # Breakfast items
        ("food_001", "Avocado Toast", "breakfast", "vegetarian,healthy,avocado,toast", 
         '{"protein_g": 12.0, "carbs_g": 35.0, "fat_g": 18.0}', 320, 
         '{"areas": ["downtown", "campus"], "chains": ["Local Cafe", "Starbucks"]}', "$$"),
        
        ("food_002", "Greek Yogurt Parfait", "breakfast", "protein,healthy,yogurt,berries", 
         '{"protein_g": 20.0, "carbs_g": 25.0, "fat_g": 8.0}', 280, 
         '{"areas": ["campus", "gym"], "chains": ["Local Cafe", "Jamba Juice"]}', "$"),
        
        ("food_003", "Protein Smoothie", "drink", "protein,smoothie,healthy,drink", 
         '{"protein_g": 25.0, "carbs_g": 20.0, "fat_g": 5.0}', 200, 
         '{"areas": ["campus", "gym"], "chains": ["Jamba Juice", "Local Smoothie"]}', "$"),
        
        ("food_004", "Oatmeal Bowl", "breakfast", "healthy,oats,breakfast,vegan", 
         '{"protein_g": 8.0, "carbs_g": 45.0, "fat_g": 6.0}', 250, 
         '{"areas": ["downtown", "campus"], "chains": ["Local Cafe", "Panera"]}', "$"),
        
        # Lunch items
        ("food_005", "Chicken Teriyaki Bowl", "bowl", "protein,asian,teriyaki,chicken", 
         '{"protein_g": 35.0, "carbs_g": 45.0, "fat_g": 12.0}', 420, 
         '{"areas": ["downtown", "campus"], "chains": ["Panda Express", "Local Asian"]}', "$$"),
        
        ("food_006", "Mediterranean Wrap", "wrap", "healthy,mediterranean,vegetarian,fresh", 
         '{"protein_g": 18.0, "carbs_g": 35.0, "fat_g": 15.0}', 320, 
         '{"areas": ["downtown", "campus", "suburbs"], "chains": ["Local Mediterranean", "Chipotle"]}', "$$"),
        
        ("food_007", "Caesar Salad", "salad", "salad,caesar,lettuce,croutons", 
         '{"protein_g": 12.0, "carbs_g": 15.0, "fat_g": 25.0}', 280, 
         '{"areas": ["downtown", "campus"], "chains": ["Local Cafe", "Panera"]}', "$$"),
        
        ("food_008", "Veggie Burger", "wrap", "vegetarian,vegan,burger,plant-based", 
         '{"protein_g": 20.0, "carbs_g": 30.0, "fat_g": 18.0}', 350, 
         '{"areas": ["downtown", "campus"], "chains": ["Local Burger", "Shake Shack"]}', "$$"),
        
        # Dinner items
        ("food_009", "Grilled Salmon", "main", "protein,fish,healthy,omega-3", 
         '{"protein_g": 40.0, "carbs_g": 5.0, "fat_g": 22.0}', 350, 
         '{"areas": ["downtown", "suburbs"], "chains": ["Local Seafood", "Red Lobster"]}', "$$$"),
        
        ("food_010", "Quinoa Buddha Bowl", "bowl", "vegan,healthy,quinoa,vegetables", 
         '{"protein_g": 15.0, "carbs_g": 50.0, "fat_g": 12.0}', 380, 
         '{"areas": ["downtown", "campus"], "chains": ["Local Healthy", "Sweetgreen"]}', "$$"),
        
        ("food_011", "Pasta Primavera", "main", "vegetarian,pasta,vegetables,italian", 
         '{"protein_g": 18.0, "carbs_g": 65.0, "fat_g": 15.0}', 450, 
         '{"areas": ["downtown", "suburbs"], "chains": ["Local Italian", "Olive Garden"]}', "$$"),
        
        ("food_012", "Beef Stir Fry", "main", "protein,asian,beef,vegetables", 
         '{"protein_g": 30.0, "carbs_g": 25.0, "fat_g": 20.0}', 400, 
         '{"areas": ["downtown", "campus"], "chains": ["Local Asian", "Panda Express"]}', "$$"),
        
        # Snacks
        ("food_013", "Mixed Nuts", "snack", "protein,healthy,nuts,trail-mix", 
         '{"protein_g": 15.0, "carbs_g": 10.0, "fat_g": 25.0}', 300, 
         '{"areas": ["campus", "gym"], "chains": ["Local Store", "Whole Foods"]}', "$"),
        
        ("food_014", "Protein Bar", "snack", "protein,convenient,bar,healthy", 
         '{"protein_g": 20.0, "carbs_g": 15.0, "fat_g": 8.0}', 200, 
         '{"areas": ["campus", "gym"], "chains": ["Local Store", "GNC"]}', "$"),
        
        ("food_015", "Fresh Fruit", "snack", "healthy,fruit,vitamins,fresh", 
         '{"protein_g": 2.0, "carbs_g": 25.0, "fat_g": 0.5}', 100, 
         '{"areas": ["campus", "downtown"], "chains": ["Local Store", "Whole Foods"]}', "$"),
        
        # Drinks
        ("food_016", "Green Tea", "drink", "healthy,tea,antioxidants,low-calorie", 
         '{"protein_g": 0.0, "carbs_g": 0.0, "fat_g": 0.0}', 0, 
         '{"areas": ["campus", "downtown"], "chains": ["Local Cafe", "Starbucks"]}', "$"),
        
        ("food_017", "Coconut Water", "drink", "healthy,hydration,electrolytes,natural", 
         '{"protein_g": 2.0, "carbs_g": 8.0, "fat_g": 0.0}', 40, 
         '{"areas": ["campus", "gym"], "chains": ["Local Store", "Whole Foods"]}', "$"),
        
        ("food_018", "Protein Shake", "drink", "protein,convenient,shake,post-workout", 
         '{"protein_g": 30.0, "carbs_g": 10.0, "fat_g": 3.0}', 180, 
         '{"areas": ["gym", "campus"], "chains": ["GNC", "Local Store"]}', "$"),
    ]
    
    for food in foods_data:
        cursor.execute('''
            INSERT OR REPLACE INTO foods 
            (id, name, category, tags, macros, kcal, availability, est_price_range)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        ''', food)
    
    # Insert test users
    users_data = [
        ("user_001", "alice_nutrition", "alice@example.com"),
        ("user_002", "bob_fitness", "bob@example.com"),
        ("user_003", "charlie_vegan", "charlie@example.com"),
        ("user_004", "diana_athlete", "diana@example.com"),
        ("user_005", "eve_student", "eve@example.com"),
    ]
    
    for user in users_data:
        cursor.execute('''
            INSERT OR REPLACE INTO users (id, username, email)
            VALUES (?, ?, ?)
        ''', user)
    
    # Insert user preferences
    preferences_data = [
        ("user_001", "omnivore", "[]", "$$", "downtown"),
        ("user_002", "omnivore", "['seafood']", "$$$", "suburbs"),
        ("user_003", "vegan", "['dairy', 'meat', 'eggs']", "$$", "campus"),
        ("user_004", "omnivore", "['processed_foods']", "$$$", "downtown"),
        ("user_005", "vegetarian", "['meat', 'fish']", "$", "campus"),
    ]
    
    for pref in preferences_data:
        cursor.execute('''
            INSERT OR REPLACE INTO user_preferences 
            (user_id, diet_style, dislikes, budget, home_area)
            VALUES (?, ?, ?, ?, ?)
        ''', pref)
    
    # Insert health contexts
    health_data = [
        ("user_001", 7.5, "moderate", "normal", 65.0, 165.0, 28),
        ("user_002", 8.0, "high", "high", 80.0, 180.0, 32),
        ("user_003", 6.5, "low", "low", 55.0, 160.0, 25),
        ("user_004", 9.0, "very_high", "high", 70.0, 175.0, 29),
        ("user_005", 7.0, "moderate", "normal", 60.0, 170.0, 22),
    ]
    
    for health in health_data:
        cursor.execute('''
            INSERT OR REPLACE INTO health_contexts 
            (user_id, sleep_hours, activity_level, mood_energy, weight_kg, height_cm, age)
            VALUES (?, ?, ?, ?, ?, ?, ?)
        ''', health)
    
    # Insert nutrition goals
    goals_data = [
        ("goal_001", "user_001", 2000, 120.0, 250.0, 67.0, 25.0),
        ("goal_002", "user_002", 2500, 150.0, 300.0, 83.0, 30.0),
        ("goal_003", "user_003", 1800, 100.0, 225.0, 60.0, 25.0),
        ("goal_004", "user_004", 2800, 180.0, 350.0, 93.0, 35.0),
        ("goal_005", "user_005", 1900, 110.0, 240.0, 63.0, 20.0),
    ]
    
    for goal in goals_data:
        cursor.execute('''
            INSERT OR REPLACE INTO nutrition_goals 
            (id, user_id, daily_calories, protein_g, carbs_g, fat_g, fiber_g)
            VALUES (?, ?, ?, ?, ?, ?, ?)
        ''', goal)
    
    # Insert consumption logs (last 30 days)
    consumption_data = []
    base_date = datetime.now() - timedelta(days=30)
    
    for day in range(30):
        current_date = base_date + timedelta(days=day)
        
        # Each user has 2-4 meals per day
        for user_id in ["user_001", "user_002", "user_003", "user_004", "user_005"]:
            meals = ["breakfast", "lunch", "dinner", "snack"]
            num_meals = random.randint(2, 4)
            selected_meals = random.sample(meals, num_meals)
            
            for meal in selected_meals:
                # Select random food
                food_id = random.choice([f[0] for f in foods_data])
                quantity = random.uniform(0.5, 2.0)
                
                consumed_at = current_date.replace(
                    hour=random.randint(6, 22),
                    minute=random.randint(0, 59)
                )
                
                consumption_data.append((
                    f"log_{user_id}_{day}_{meal}_{random.randint(1000, 9999)}",
                    user_id,
                    food_id,
                    quantity,
                    meal,
                    consumed_at.isoformat()
                ))
    
    for log in consumption_data:
        cursor.execute('''
            INSERT OR REPLACE INTO consumption_logs 
            (id, user_id, food_id, quantity, meal_type, consumed_at)
            VALUES (?, ?, ?, ?, ?, ?)
        ''', log)
    
    conn.commit()
    conn.close()
    
    print("✅ Test database created successfully!")
    print(f"📊 Database contains:")
    print(f"   - {len(foods_data)} foods")
    print(f"   - {len(users_data)} users")
    print(f"   - {len(preferences_data)} user preferences")
    print(f"   - {len(health_data)} health contexts")
    print(f"   - {len(goals_data)} nutrition goals")
    print(f"   - {len(consumption_data)} consumption logs")

if __name__ == "__main__":
    create_test_database()
