import json
from .database import get_db
from models.food import Food, FoodCategory, PriceRange, Macros, Availability

def seed_foods():
    """Seed the database with initial food data."""
    foods_data = [
        {
            "id": "food_001",
            "name": "Chicken Teriyaki Bowl",
            "category": FoodCategory.BOWL,
            "tags": ["protein", "asian", "teriyaki", "chicken"],
            "macros": Macros(protein_g=35.0, carbs_g=45.0, fat_g=12.0),
            "kcal": 420,
            "availability": Availability(areas=["downtown", "campus"], chains=["Panda Express", "Local Asian"]),
            "est_price_range": PriceRange.MEDIUM
        },
        {
            "id": "food_002", 
            "name": "Mediterranean Wrap",
            "category": FoodCategory.WRAP,
            "tags": ["healthy", "mediterranean", "vegetarian", "fresh"],
            "macros": Macros(protein_g=18.0, carbs_g=35.0, fat_g=15.0),
            "kcal": 320,
            "availability": Availability(areas=["downtown", "campus", "suburbs"], chains=["Local Mediterranean", "Chipotle"]),
            "est_price_range": PriceRange.MEDIUM
        },
        {
            "id": "food_003",
            "name": "Caesar Salad",
            "category": FoodCategory.SALAD,
            "tags": ["salad", "caesar", "lettuce", "croutons"],
            "macros": Macros(protein_g=12.0, carbs_g=15.0, fat_g=25.0),
            "kcal": 280,
            "availability": Availability(areas=["downtown", "campus"], chains=["Local Cafe", "Panera"]),
            "est_price_range": PriceRange.MEDIUM
        },
        {
            "id": "food_004",
            "name": "Protein Smoothie",
            "category": FoodCategory.DRINK,
            "tags": ["protein", "smoothie", "healthy", "drink"],
            "macros": Macros(protein_g=25.0, carbs_g=20.0, fat_g=5.0),
            "kcal": 200,
            "availability": Availability(areas=["campus", "gym"], chains=["Jamba Juice", "Local Smoothie"]),
            "est_price_range": PriceRange.LOW
        },
        {
            "id": "food_005",
            "name": "Veggie Burger",
            "category": FoodCategory.WRAP,
            "tags": ["vegetarian", "vegan", "burger", "plant-based"],
            "macros": Macros(protein_g=20.0, carbs_g=30.0, fat_g=18.0),
            "kcal": 350,
            "availability": Availability(areas=["downtown", "campus"], chains=["Local Burger", "Shake Shack"]),
            "est_price_range": PriceRange.MEDIUM
        }
    ]
    
    with get_db() as conn:
        cursor = conn.cursor()
        
        for food_data in foods_data:
            food = Food(**food_data)
            cursor.execute("""
                INSERT OR REPLACE INTO foods 
                (id, name, category, tags, protein_g, carbs_g, fat_g, kcal, areas, chains, est_price_range)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            """, (
                food.id,
                food.name,
                food.category,
                json.dumps(food.tags),
                food.macros.protein_g,
                food.macros.carbs_g,
                food.macros.fat_g,
                food.kcal,
                json.dumps(food.availability.areas),
                json.dumps(food.availability.chains),
                food.est_price_range
            ))
        
        conn.commit()
        print(f"Seeded {len(foods_data)} foods into the database")
