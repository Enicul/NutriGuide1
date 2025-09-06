import Foundation

class ExpandedFoodDatabase: ObservableObject {
    static let shared = ExpandedFoodDatabase()
    
    @Published var allFoods: [Food] = []
    
    private init() {
        loadFoodDatabase()
    }
    
    private func loadFoodDatabase() {
        allFoods = [
            // Protein-rich foods
            Food(
                name: "Grilled Chicken Breast",
                emoji: "🍗",
                nutrition: Nutrition(kcal: 165, carbs: 0, protein: 31, fat: 3.6, micros: ["Mg": 25, "B6": 0.5, "Zn": 0.8]),
                tags: ["high-protein", "lean", "muscle-recovery"],
                portionText: "100g serving",
                dietFlags: ["Gluten-Free", "Keto", "Paleo"],
                allergyFlags: [],
                rationale: "Complete protein source for muscle recovery and repair"
            ),
            
            Food(
                name: "Salmon Fillet",
                emoji: "🐟",
                nutrition: Nutrition(kcal: 208, carbs: 0, protein: 25, fat: 12, micros: ["Omega-3": 2.3, "D": 11, "B12": 2.4]),
                tags: ["high-protein", "omega-3", "brain-health"],
                portionText: "100g serving",
                dietFlags: ["Gluten-Free", "Keto", "Paleo"],
                allergyFlags: ["Fish"],
                rationale: "Rich in omega-3 fatty acids and complete protein for brain and heart health"
            ),
            
            Food(
                name: "Greek Yogurt",
                emoji: "🥛",
                nutrition: Nutrition(kcal: 100, carbs: 6, protein: 17, fat: 0.4, micros: ["Ca": 200, "B12": 0.5, "Probiotics": 1]),
                tags: ["high-protein", "probiotic", "calcium"],
                portionText: "170g container",
                dietFlags: ["Vegetarian"],
                allergyFlags: ["Dairy"],
                rationale: "High protein with probiotics for gut health and muscle recovery"
            ),
            
            Food(
                name: "Lentils",
                emoji: "🫘",
                nutrition: Nutrition(kcal: 116, carbs: 20, protein: 9, fat: 0.4, micros: ["Fe": 3.3, "Folate": 90, "Mg": 36]),
                tags: ["plant-protein", "fiber", "iron"],
                portionText: "100g cooked",
                dietFlags: ["Vegan", "Vegetarian", "Gluten-Free"],
                allergyFlags: [],
                rationale: "Plant-based protein with iron and folate for energy and blood health"
            ),
            
            // Magnesium-rich foods
            Food(
                name: "Dark Chocolate (85%)",
                emoji: "🍫",
                nutrition: Nutrition(kcal: 170, carbs: 13, protein: 2.7, fat: 12, micros: ["Mg": 64, "Fe": 3.3, "Antioxidants": 15]),
                tags: ["magnesium", "antioxidant", "stress-relief"],
                portionText: "30g (3-4 pieces)",
                dietFlags: ["Vegetarian"],
                allergyFlags: ["Dairy (check label)"],
                rationale: "Rich in magnesium and antioxidants for stress relief and heart health"
            ),
            
            Food(
                name: "Almonds",
                emoji: "🥜",
                nutrition: Nutrition(kcal: 164, carbs: 6, protein: 6, fat: 14, micros: ["Mg": 76, "E": 7.3, "Ca": 75]),
                tags: ["magnesium", "healthy-fats", "vitamin-e"],
                portionText: "28g (23 almonds)",
                dietFlags: ["Vegan", "Gluten-Free", "Keto"],
                allergyFlags: ["Nuts"],
                rationale: "High magnesium content for muscle function and stress management"
            ),
            
            Food(
                name: "Spinach",
                emoji: "🥬",
                nutrition: Nutrition(kcal: 23, carbs: 3.6, protein: 2.9, fat: 0.4, micros: ["Mg": 79, "Fe": 2.7, "K": 558, "Folate": 194]),
                tags: ["magnesium", "iron", "folate"],
                portionText: "100g raw",
                dietFlags: ["Vegan", "Vegetarian", "Gluten-Free"],
                allergyFlags: [],
                rationale: "Nutrient-dense leafy green with magnesium, iron, and folate"
            ),
            
            Food(
                name: "Pumpkin Seeds",
                emoji: "🎃",
                nutrition: Nutrition(kcal: 446, carbs: 18, protein: 19, fat: 35, micros: ["Mg": 262, "Zn": 7.6, "Fe": 3.3]),
                tags: ["magnesium", "zinc", "protein"],
                portionText: "28g (1/4 cup)",
                dietFlags: ["Vegan", "Vegetarian", "Gluten-Free"],
                allergyFlags: ["Seeds"],
                rationale: "Exceptionally high in magnesium and zinc for immune function"
            ),
            
            // Tryptophan-rich foods
            Food(
                name: "Turkey Breast",
                emoji: "🦃",
                nutrition: Nutrition(kcal: 135, carbs: 0, protein: 25, fat: 3, micros: ["Tryptophan": 0.3, "B6": 0.6, "Zn": 1.5]),
                tags: ["tryptophan", "sleep-support", "lean-protein"],
                portionText: "100g serving",
                dietFlags: ["Gluten-Free", "Keto"],
                allergyFlags: [],
                rationale: "Rich in tryptophan for better sleep quality and mood regulation"
            ),
            
            Food(
                name: "Oatmeal",
                emoji: "🥣",
                nutrition: Nutrition(kcal: 154, carbs: 27, protein: 5, fat: 3, micros: ["Tryptophan": 0.1, "Mg": 63, "B1": 0.2]),
                tags: ["tryptophan", "complex-carbs", "fiber"],
                portionText: "40g dry (1/2 cup)",
                dietFlags: ["Vegan", "Vegetarian", "Gluten-Free"],
                allergyFlags: [],
                rationale: "Complex carbs help tryptophan reach the brain for better sleep"
            ),
            
            Food(
                name: "Milk",
                emoji: "🥛",
                nutrition: Nutrition(kcal: 42, carbs: 5, protein: 3.4, fat: 1, micros: ["Tryptophan": 0.1, "Ca": 113, "D": 2.5]),
                tags: ["tryptophan", "calcium", "sleep-support"],
                portionText: "100ml",
                dietFlags: ["Vegetarian"],
                allergyFlags: ["Dairy"],
                rationale: "Classic bedtime drink with tryptophan and calcium for relaxation"
            ),
            
            Food(
                name: "Walnuts",
                emoji: "🌰",
                nutrition: Nutrition(kcal: 185, carbs: 4, protein: 4, fat: 18, micros: ["Tryptophan": 0.1, "Omega-3": 2.6, "Mg": 45]),
                tags: ["tryptophan", "omega-3", "brain-health"],
                portionText: "28g (7 halves)",
                dietFlags: ["Vegan", "Vegetarian", "Gluten-Free"],
                allergyFlags: ["Nuts"],
                rationale: "Tryptophan and omega-3 for brain health and sleep quality"
            ),
            
            // Hydration foods
            Food(
                name: "Coconut Water",
                emoji: "🥥",
                nutrition: Nutrition(kcal: 19, carbs: 4, protein: 0.7, fat: 0.2, micros: ["K": 600, "Na": 252, "Mg": 60]),
                tags: ["electrolytes", "hydrating", "natural"],
                portionText: "240ml (1 cup)",
                dietFlags: ["Vegan", "Vegetarian", "Gluten-Free"],
                allergyFlags: [],
                rationale: "Natural electrolytes for optimal hydration and muscle function"
            ),
            
            Food(
                name: "Watermelon",
                emoji: "🍉",
                nutrition: Nutrition(kcal: 30, carbs: 8, protein: 0.6, fat: 0.2, micros: ["Water": 92, "C": 8.1, "Lycopene": 4.5]),
                tags: ["hydrating", "antioxidant", "low-calorie"],
                portionText: "150g slice",
                dietFlags: ["Vegan", "Vegetarian", "Gluten-Free"],
                allergyFlags: [],
                rationale: "92% water content with natural electrolytes and antioxidants"
            ),
            
            Food(
                name: "Cucumber",
                emoji: "🥒",
                nutrition: Nutrition(kcal: 16, carbs: 4, protein: 0.7, fat: 0.1, micros: ["Water": 96, "K": 147, "C": 2.8]),
                tags: ["hydrating", "low-calorie", "detox"],
                portionText: "100g",
                dietFlags: ["Vegan", "Vegetarian", "Gluten-Free"],
                allergyFlags: [],
                rationale: "96% water content with potassium for hydration and detox"
            ),
            
            Food(
                name: "Herbal Tea",
                emoji: "🍵",
                nutrition: Nutrition(kcal: 2, carbs: 0.4, protein: 0, fat: 0, micros: ["Antioxidants": 1, "C": 0.1]),
                tags: ["hydrating", "antioxidant", "calming"],
                portionText: "240ml cup",
                dietFlags: ["Vegan", "Vegetarian", "Gluten-Free"],
                allergyFlags: [],
                rationale: "Hydrating with calming properties and antioxidants"
            ),
            
            // General healthy foods
            Food(
                name: "Avocado",
                emoji: "🥑",
                nutrition: Nutrition(kcal: 160, carbs: 9, protein: 2, fat: 15, micros: ["K": 485, "Folate": 81, "E": 2.1]),
                tags: ["healthy-fats", "fiber", "potassium"],
                portionText: "100g (1/2 medium)",
                dietFlags: ["Vegan", "Vegetarian", "Gluten-Free", "Keto"],
                allergyFlags: [],
                rationale: "Healthy monounsaturated fats and fiber for heart health"
            ),
            
            Food(
                name: "Quinoa",
                emoji: "🌾",
                nutrition: Nutrition(kcal: 120, carbs: 22, protein: 4.4, fat: 1.9, micros: ["Mg": 64, "Fe": 1.5, "Lysine": 0.2]),
                tags: ["complete-protein", "fiber", "gluten-free"],
                portionText: "100g cooked",
                dietFlags: ["Vegan", "Vegetarian", "Gluten-Free"],
                allergyFlags: [],
                rationale: "Complete plant protein with all essential amino acids"
            ),
            
            Food(
                name: "Blueberries",
                emoji: "🫐",
                nutrition: Nutrition(kcal: 57, carbs: 14, protein: 0.7, fat: 0.3, micros: ["C": 9.7, "K": 77, "Antioxidants": 13.4]),
                tags: ["antioxidant", "brain-health", "low-sugar"],
                portionText: "100g (3/4 cup)",
                dietFlags: ["Vegan", "Vegetarian", "Gluten-Free"],
                allergyFlags: [],
                rationale: "High in antioxidants for brain health and anti-aging"
            ),
            
            Food(
                name: "Sweet Potato",
                emoji: "🍠",
                nutrition: Nutrition(kcal: 86, carbs: 20, protein: 1.6, fat: 0.1, micros: ["A": 14187, "C": 2.4, "K": 337]),
                tags: ["complex-carbs", "vitamin-a", "fiber"],
                portionText: "100g (1/2 medium)",
                dietFlags: ["Vegan", "Vegetarian", "Gluten-Free"],
                allergyFlags: [],
                rationale: "Complex carbohydrates with beta-carotene for immune support"
            ),
            
            Food(
                name: "Broccoli",
                emoji: "🥦",
                nutrition: Nutrition(kcal: 34, carbs: 7, protein: 2.8, fat: 0.4, micros: ["C": 89, "K": 101, "Folate": 63]),
                tags: ["vitamin-c", "fiber", "cancer-fighting"],
                portionText: "100g (1 cup)",
                dietFlags: ["Vegan", "Vegetarian", "Gluten-Free"],
                allergyFlags: [],
                rationale: "High in vitamin C and sulforaphane for immune and cellular health"
            ),
            
            // Energy-boosting foods
            Food(
                name: "Banana",
                emoji: "🍌",
                nutrition: Nutrition(kcal: 89, carbs: 23, protein: 1.1, fat: 0.3, micros: ["K": 358, "B6": 0.4, "Mg": 27]),
                tags: ["energy", "potassium", "pre-workout"],
                portionText: "1 medium (120g)",
                dietFlags: ["Vegan", "Vegetarian", "Gluten-Free"],
                allergyFlags: [],
                rationale: "Natural energy with potassium and B6 for muscle function"
            ),
            
            Food(
                name: "Oats",
                emoji: "🌾",
                nutrition: Nutrition(kcal: 68, carbs: 12, protein: 2.4, fat: 1.4, micros: ["Mg": 27, "Zn": 0.6, "B1": 0.1]),
                tags: ["sustained-energy", "fiber", "beta-glucan"],
                portionText: "40g dry (1/2 cup)",
                dietFlags: ["Vegan", "Vegetarian", "Gluten-Free"],
                allergyFlags: [],
                rationale: "Sustained energy release with beta-glucan for heart health"
            ),
            
            Food(
                name: "Green Tea",
                emoji: "🍵",
                nutrition: Nutrition(kcal: 2, carbs: 0, protein: 0, fat: 0, micros: ["Caffeine": 25, "L-Theanine": 8, "EGCG": 50]),
                tags: ["energy", "antioxidant", "focus"],
                portionText: "240ml cup",
                dietFlags: ["Vegan", "Vegetarian", "Gluten-Free"],
                allergyFlags: [],
                rationale: "Gentle caffeine with L-theanine for sustained focus and energy"
            ),
            
            // Recovery foods
            Food(
                name: "Cherries",
                emoji: "🍒",
                nutrition: Nutrition(kcal: 50, carbs: 12, protein: 1, fat: 0.3, micros: ["C": 7, "K": 173, "Melatonin": 0.1]),
                tags: ["recovery", "anti-inflammatory", "sleep"],
                portionText: "100g (3/4 cup)",
                dietFlags: ["Vegan", "Vegetarian", "Gluten-Free"],
                allergyFlags: [],
                rationale: "Natural melatonin and anti-inflammatory compounds for recovery"
            ),
            
            Food(
                name: "Ginger",
                emoji: "🫚",
                nutrition: Nutrition(kcal: 80, carbs: 18, protein: 1.8, fat: 0.8, micros: ["Gingerol": 2.5, "Mg": 43, "K": 415]),
                tags: ["anti-inflammatory", "digestive", "recovery"],
                portionText: "100g",
                dietFlags: ["Vegan", "Vegetarian", "Gluten-Free"],
                allergyFlags: [],
                rationale: "Anti-inflammatory gingerol for muscle recovery and digestion"
            ),
            
            Food(
                name: "Turmeric",
                emoji: "🫚",
                nutrition: Nutrition(kcal: 354, carbs: 65, protein: 8, fat: 10, micros: ["Curcumin": 3.1, "Fe": 41, "Mn": 7.8]),
                tags: ["anti-inflammatory", "antioxidant", "recovery"],
                portionText: "100g powder",
                dietFlags: ["Vegan", "Vegetarian", "Gluten-Free"],
                allergyFlags: [],
                rationale: "Curcumin for powerful anti-inflammatory and recovery benefits"
            )
        ]
    }
    
    func searchFoods(for nutrient: String, limit: Int = 10) -> [Food] {
        let nutrientLowercased = nutrient.lowercased()
        
        return allFoods.filter { food in
            food.tags.contains { $0.lowercased().contains(nutrientLowercased) } ||
            food.name.lowercased().contains(nutrientLowercased) ||
            food.rationale.lowercased().contains(nutrientLowercased)
        }.prefix(limit).map { $0 }
    }
    
    func getFoodsByTag(_ tag: String) -> [Food] {
        return allFoods.filter { $0.tags.contains(tag) }
    }
    
    func getRandomFoods(count: Int = 5) -> [Food] {
        return Array(allFoods.shuffled().prefix(count))
    }
}

