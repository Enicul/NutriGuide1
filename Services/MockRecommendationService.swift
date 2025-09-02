import Foundation

struct MockRecommendationService {
    
    func recommendation(for state: UserState) -> Recommendation {
        switch state {
        case .stressed:
            return Recommendation(
                state: .stressed,
                reason: "HRV lower vs baseline • Late afternoon dip • Suggest Mg + B6 for relaxation",
                foods: [
                    Food(
                        name: "Banana",
                        emoji: "🍌",
                        nutrition: Nutrition(kcal: 105, carbs: 27, protein: 1.3, fat: 0.4, micros: ["Mg": 32, "B6": 0.4]),
                        tags: ["common"],
                        portionText: "1 medium (120 g)",
                        dietFlags: ["Vegetarian", "Halal"],
                        allergyFlags: [],
                        rationale: "Rich in magnesium and B6, helps relieve stress and anxiety"
                    ),
                    Food(
                        name: "Dark Chocolate (70%+)",
                        emoji: "🍫",
                        nutrition: Nutrition(kcal: 170, carbs: 13, protein: 2.7, fat: 12, micros: ["Mg": 64]),
                        tags: ["treat"],
                        portionText: "30 g (3-4 pieces)",
                        dietFlags: ["Vegetarian"],
                        allergyFlags: ["Dairy (check label)"],
                        rationale: "High magnesium content, theobromine helps improve mood"
                    ),
                    Food(
                        name: "Yogurt",
                        emoji: "🥣",
                        nutrition: Nutrition(kcal: 120, carbs: 9, protein: 10, fat: 4, micros: ["Ca": 200]),
                        tags: ["protein"],
                        portionText: "150 g cup",
                        dietFlags: [],
                        allergyFlags: ["Dairy"],
                        rationale: "Probiotics support gut health, protein stabilizes blood sugar"
                    )
                ]
            )
            
        case .lowEnergy:
            return Recommendation(
                state: .lowEnergy,
                reason: "Blood sugar levels low • Need quick energy boost • Suggest complex carbohydrates",
                foods: [
                    Food(
                        name: "Oatmeal",
                        emoji: "🥣",
                        nutrition: Nutrition(kcal: 150, carbs: 27, protein: 5, fat: 3, micros: ["B1": 0.2, "Mg": 25]),
                        tags: ["staple"],
                        portionText: "40 g dry weight",
                        dietFlags: ["Vegan"],
                        allergyFlags: ["Gluten (unless gluten-free)"],
                        rationale: "Complex carbohydrates provide sustained energy"
                    ),
                    Food(
                        name: "Greek Yogurt",
                        emoji: "🥛",
                        nutrition: Nutrition(kcal: 120, carbs: 5, protein: 17, fat: 0, micros: ["Ca": 180]),
                        tags: ["protein"],
                        portionText: "170 g",
                        dietFlags: [],
                        allergyFlags: ["Dairy"],
                        rationale: "High protein, provides quick energy"
                    ),
                    Food(
                        name: "Apple",
                        emoji: "🍎",
                        nutrition: Nutrition(kcal: 95, carbs: 25, protein: 0.5, fat: 0.3, micros: ["K": 195]),
                        tags: ["common"],
                        portionText: "1 medium (180 g)",
                        dietFlags: ["Vegan", "Halal"],
                        allergyFlags: [],
                        rationale: "Natural sugars quickly boost blood sugar"
                    )
                ]
            )
            
        case .postWorkout:
            return Recommendation(
                state: .postWorkout,
                reason: "Post-workout recovery • Need protein and carbohydrates • Promote muscle repair",
                foods: [
                    Food(
                        name: "Chicken Breast",
                        emoji: "🍗",
                        nutrition: Nutrition(kcal: 165, carbs: 0, protein: 31, fat: 3.6, micros: ["B6": 0.8, "Zn": 1.0]),
                        tags: ["protein"],
                        portionText: "100 g",
                        dietFlags: [],
                        allergyFlags: [],
                        rationale: "High protein, promotes muscle repair"
                    ),
                    Food(
                        name: "Sweet Potato",
                        emoji: "🍠",
                        nutrition: Nutrition(kcal: 112, carbs: 26, protein: 2, fat: 0.1, micros: ["K": 337, "A": 18443]),
                        tags: ["staple"],
                        portionText: "1 medium (130 g)",
                        dietFlags: ["Vegan", "Halal"],
                        allergyFlags: [],
                        rationale: "Complex carbohydrates replenish glycogen"
                    ),
                    Food(
                        name: "Almonds",
                        emoji: "🥜",
                        nutrition: Nutrition(kcal: 164, carbs: 6, protein: 6, fat: 14, micros: ["Mg": 76, "E": 7.3]),
                        tags: ["healthy-fat"],
                        portionText: "28 g (about 23 pieces)",
                        dietFlags: ["Vegan", "Halal"],
                        allergyFlags: ["Nuts"],
                        rationale: "Healthy fats and vitamin E, anti-inflammatory effects"
                    )
                ]
            )
            
        case .sleepPrep:
            return Recommendation(
                state: .sleepPrep,
                reason: "Preparing for sleep • Need to promote melatonin secretion • Avoid stimulating foods",
                foods: [
                    Food(
                        name: "Cherries",
                        emoji: "🍒",
                        nutrition: Nutrition(kcal: 50, carbs: 12, protein: 1, fat: 0.3, micros: ["C": 7, "K": 173]),
                        tags: ["sleep-aid"],
                        portionText: "100 g (about 10 pieces)",
                        dietFlags: ["Vegan", "Halal"],
                        allergyFlags: [],
                        rationale: "Natural melatonin source, promotes sleep"
                    ),
                    Food(
                        name: "Oatmeal Porridge",
                        emoji: "🥣",
                        nutrition: Nutrition(kcal: 150, carbs: 27, protein: 5, fat: 3, micros: ["Mg": 25, "B6": 0.1]),
                        tags: ["staple"],
                        portionText: "40 g dry weight",
                        dietFlags: ["Vegan"],
                        allergyFlags: ["Gluten (unless gluten-free)"],
                        rationale: "Magnesium and B6 help relax nerves"
                    ),
                    Food(
                        name: "Banana",
                        emoji: "🍌",
                        nutrition: Nutrition(kcal: 105, carbs: 27, protein: 1.3, fat: 0.4, micros: ["Mg": 32, "B6": 0.4]),
                        tags: ["common"],
                        portionText: "1 medium (120 g)",
                        dietFlags: ["Vegetarian", "Halal"],
                        allergyFlags: [],
                        rationale: "Tryptophan and magnesium, natural sleep aid"
                    )
                ]
            )
            
        case .focusNeeded:
            return Recommendation(
                state: .focusNeeded,
                reason: "Need to improve focus • Suggest stable blood sugar and brain nutrition • Avoid blood sugar fluctuations",
                foods: [
                    Food(
                        name: "Blueberries",
                        emoji: "🫐",
                        nutrition: Nutrition(kcal: 57, carbs: 14, protein: 0.7, fat: 0.3, micros: ["C": 9.7, "K": 77]),
                        tags: ["brain-food"],
                        portionText: "100 g (about 1 cup)",
                        dietFlags: ["Vegan", "Halal"],
                        allergyFlags: [],
                        rationale: "Antioxidants protect brain cells, improve cognitive function"
                    ),
                    Food(
                        name: "Walnuts",
                        emoji: "🥜",
                        nutrition: Nutrition(kcal: 185, carbs: 4, protein: 4, fat: 18, micros: ["Mg": 45, "E": 0.7]),
                        tags: ["healthy-fat"],
                        portionText: "28 g (about 7 pieces)",
                        dietFlags: ["Vegan", "Halal"],
                        allergyFlags: ["Nuts"],
                        rationale: "Omega-3 fatty acids, support brain health"
                    ),
                    Food(
                        name: "Green Tea",
                        emoji: "🍵",
                        nutrition: Nutrition(kcal: 2, carbs: 0, protein: 0, fat: 0, micros: ["C": 6, "K": 8]),
                        tags: ["beverage"],
                        portionText: "240 ml",
                        dietFlags: ["Vegan", "Halal"],
                        allergyFlags: [],
                        rationale: "L-theanine and moderate caffeine, improves focus"
                    )
                ]
            )
            
        case .calm:
            return Recommendation(
                state: .calm,
                reason: "Mind and body relaxed state • Maintain balanced nutrition • Support overall health",
                foods: [
                    Food(
                        name: "Avocado",
                        emoji: "🥑",
                        nutrition: Nutrition(kcal: 160, carbs: 9, protein: 2, fat: 15, micros: ["K": 485, "E": 2.1]),
                        tags: ["healthy-fat"],
                        portionText: "1/2 medium (100 g)",
                        dietFlags: ["Vegan", "Halal"],
                        allergyFlags: [],
                        rationale: "Healthy monounsaturated fats, support cardiovascular health"
                    ),
                    Food(
                        name: "Salmon",
                        emoji: "🐟",
                        nutrition: Nutrition(kcal: 208, carbs: 0, protein: 25, fat: 12, micros: ["B12": 3.2, "D": 11]),
                        tags: ["protein"],
                        portionText: "100 g",
                        dietFlags: [],
                        allergyFlags: ["Fish"],
                        rationale: "Omega-3 fatty acids, anti-inflammatory and heart health"
                    ),
                    Food(
                        name: "Spinach",
                        emoji: "🥬",
                        nutrition: Nutrition(kcal: 23, carbs: 3.6, protein: 2.9, fat: 0.4, micros: ["K": 558, "Fe": 2.7, "A": 469]),
                        tags: ["leafy-green"],
                        portionText: "100 g raw weight",
                        dietFlags: ["Vegan", "Halal"],
                        allergyFlags: [],
                        rationale: "Folate and iron, support blood and nervous system"
                    )
                ]
            )
        }
    }
}

extension MockRecommendationService {
    func filtered(_ foods: [Food], using settings: UserSettings) -> [Food] {
        // 1) Apply allergies & dietary preferences
        let compliant = foods.filter { food in
            // Allergy exclusion by simple keyword match on allergyFlags
            let allergyHit = settings.allergies.contains { a in
                food.allergyFlags.map { $0.lowercased() }.contains { $0.contains(a.rawValue.lowercased()) }
            }
            if allergyHit { return false }
            
            // Diet preference inclusion: if user has prefs, food must match ALL selected
            if !settings.preferences.isEmpty {
                let foodFlags = Set(food.dietFlags.map { $0.lowercased() })
                for pref in settings.preferences {
                    // map preference to expected flag tokens
                    let token = pref.label.lowercased()
                    if !foodFlags.contains(where: { $0.contains(token) }) { return false }
                }
            }
            return true
        }
        
        // 2) Prefer pantry-enabled first; then fill with remaining compliant
        let pantryNames = Set(settings.pantry.filter(\.enabled).map { $0.name.lowercased() })
        let pantryFirst = compliant.sorted { a, b in
            let aIn = pantryNames.contains(a.name.lowercased())
            let bIn = pantryNames.contains(b.name.lowercased())
            if aIn == bIn { return a.name < b.name }
            return aIn && !bIn
        }
        
        // keep at most 3
        return Array(pantryFirst.prefix(3))
    }
}
