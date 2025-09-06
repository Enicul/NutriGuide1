import Foundation

// MARK: - Nutritional Recommendation Models
struct NutritionalRecommendation: Codable, Identifiable {
    let id = UUID()
    let timestamp: Date
    let healthData: HealthData
    let macronutrients: MacronutrientRecommendation
    let micronutrients: MicronutrientRecommendation
    let hydration: HydrationRecommendation
    let timing: TimingRecommendation
    
    var priorityNutrients: [PriorityNutrient] {
        var priorities: [PriorityNutrient] = []
        
        // Add macro priorities based on health data
        if healthData.activityData.healthScore > 0.7 {
            priorities.append(PriorityNutrient(
                nutrient: "Protein",
                currentIntake: macronutrients.protein.current,
                recommendedIntake: macronutrients.protein.recommended,
                priority: .high,
                reason: "High activity level requires increased protein for muscle recovery"
            ))
        }
        
        if healthData.stressLevel.healthScore < 0.5 {
            priorities.append(PriorityNutrient(
                nutrient: "Magnesium",
                currentIntake: micronutrients.magnesium.current,
                recommendedIntake: micronutrients.magnesium.recommended,
                priority: .high,
                reason: "Stress management requires adequate magnesium levels"
            ))
        }
        
        if healthData.sleepData.healthScore < 0.6 {
            priorities.append(PriorityNutrient(
                nutrient: "Tryptophan",
                currentIntake: micronutrients.tryptophan.current,
                recommendedIntake: micronutrients.tryptophan.recommended,
                priority: .medium,
                reason: "Sleep quality improvement through tryptophan-rich foods"
            ))
        }
        
        if healthData.hydrationLevel.healthScore < 0.6 {
            priorities.append(PriorityNutrient(
                nutrient: "Water",
                currentIntake: hydration.current,
                recommendedIntake: hydration.recommended,
                priority: .high,
                reason: "Inadequate hydration levels detected"
            ))
        }
        
        return priorities
    }
}

struct MacronutrientRecommendation: Codable {
    let protein: NutrientIntake
    let carbohydrates: NutrientIntake
    let fat: NutrientIntake
    let fiber: NutrientIntake
    
    var totalCalories: Double {
        return protein.calories + carbohydrates.calories + fat.calories
    }
}

struct MicronutrientRecommendation: Codable {
    let vitamins: [VitaminRecommendation]
    let minerals: [MineralRecommendation]
    let antioxidants: [AntioxidantRecommendation]
    
    var allNutrients: [String: Double] {
        var nutrients: [String: Double] = [:]
        
        for vitamin in vitamins {
            nutrients[vitamin.name] = vitamin.recommended
        }
        
        for mineral in minerals {
            nutrients[mineral.name] = mineral.recommended
        }
        
        for antioxidant in antioxidants {
            nutrients[antioxidant.name] = antioxidant.recommended
        }
        
        return nutrients
    }
}

struct NutrientIntake: Codable {
    let current: Double
    let recommended: Double
    let unit: String
    
    var calories: Double {
        switch unit {
        case "g":
            // Rough calorie estimates per gram
            if self === protein { return current * 4 }
            if self === carbohydrates { return current * 4 }
            if self === fat { return current * 9 }
            return current * 4
        default:
            return 0
        }
    }
    
    var deficit: Double {
        return max(0, recommended - current)
    }
    
    var surplus: Double {
        return max(0, current - recommended)
    }
    
    var isDeficient: Bool {
        return current < recommended * 0.8
    }
    
    var isExcessive: Bool {
        return current > recommended * 1.2
    }
}

struct VitaminRecommendation: Codable {
    let name: String
    let current: Double
    let recommended: Double
    let unit: String
    let benefits: [String]
}

struct MineralRecommendation: Codable {
    let name: String
    let current: Double
    let recommended: Double
    let unit: String
    let benefits: [String]
}

struct AntioxidantRecommendation: Codable {
    let name: String
    let current: Double
    let recommended: Double
    let unit: String
    let benefits: [String]
}

struct HydrationRecommendation: Codable {
    let current: Double // liters
    let recommended: Double // liters
    let additionalNeeds: Double // liters
    let timing: [String] // when to drink
    
    var deficit: Double {
        return max(0, recommended - current)
    }
}

struct TimingRecommendation: Codable {
    let mealTiming: [MealTiming]
    let preWorkout: String?
    let postWorkout: String?
    let bedtime: String?
}

struct MealTiming: Codable {
    let meal: String
    let time: String
    let priority: String
    let focus: [String]
}

struct PriorityNutrient: Codable, Identifiable {
    let id = UUID()
    let nutrient: String
    let currentIntake: Double
    let recommendedIntake: Double
    let priority: Priority
    let reason: String
    
    enum Priority: String, CaseIterable, Codable {
        case high = "High"
        case medium = "Medium"
        case low = "Low"
        
        var color: String {
            switch self {
            case .high: return "red"
            case .medium: return "orange"
            case .low: return "green"
            }
        }
    }
}

// MARK: - Nutritional Recommendation Service
class NutritionalRecommendationService: ObservableObject {
    @Published var currentRecommendation: NutritionalRecommendation?
    @Published var isProcessing = false
    
    func generateRecommendation(from healthData: HealthData) {
        isProcessing = true
        
        // Simulate AI processing time
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.currentRecommendation = self.createRecommendation(from: healthData)
            self.isProcessing = false
        }
    }
    
    private func createRecommendation(from healthData: HealthData) -> NutritionalRecommendation {
        let baseProtein = 1.6 // g per kg body weight (assuming 70kg)
        let baseCarbs = 4.0 // g per kg body weight
        let baseFat = 1.0 // g per kg body weight
        
        // Adjust based on health data
        let activityMultiplier = 1.0 + (healthData.activityData.healthScore * 0.5)
        let stressMultiplier = 1.0 + ((1.0 - healthData.stressLevel.healthScore) * 0.3)
        let sleepMultiplier = 1.0 + ((1.0 - healthData.sleepData.healthScore) * 0.2)
        
        let proteinNeeds = baseProtein * activityMultiplier * stressMultiplier
        let carbNeeds = baseCarbs * activityMultiplier
        let fatNeeds = baseFat * sleepMultiplier
        
        return NutritionalRecommendation(
            timestamp: Date(),
            healthData: healthData,
            macronutrients: MacronutrientRecommendation(
                protein: NutrientIntake(current: proteinNeeds * 0.7, recommended: proteinNeeds, unit: "g"),
                carbohydrates: NutrientIntake(current: carbNeeds * 0.8, recommended: carbNeeds, unit: "g"),
                fat: NutrientIntake(current: fatNeeds * 0.6, recommended: fatNeeds, unit: "g"),
                fiber: NutrientIntake(current: 15, recommended: 25, unit: "g")
            ),
            micronutrients: MicronutrientRecommendation(
                vitamins: [
                    VitaminRecommendation(name: "Vitamin D", current: 800, recommended: 2000, unit: "IU", benefits: ["Bone health", "Immune function"]),
                    VitaminRecommendation(name: "B12", current: 2.4, recommended: 2.4, unit: "mcg", benefits: ["Energy production", "Nerve function"]),
                    VitaminRecommendation(name: "C", current: 65, recommended: 90, unit: "mg", benefits: ["Immune support", "Antioxidant"])
                ],
                minerals: [
                    MineralRecommendation(name: "Magnesium", current: 200, recommended: 400, unit: "mg", benefits: ["Muscle function", "Stress relief"]),
                    MineralRecommendation(name: "Iron", current: 8, recommended: 18, unit: "mg", benefits: ["Oxygen transport", "Energy"]),
                    MineralRecommendation(name: "Zinc", current: 8, recommended: 11, unit: "mg", benefits: ["Immune function", "Wound healing"])
                ],
                antioxidants: [
                    AntioxidantRecommendation(name: "Omega-3", current: 0.5, recommended: 2.0, unit: "g", benefits: ["Brain health", "Anti-inflammatory"]),
                    AntioxidantRecommendation(name: "Resveratrol", current: 0, recommended: 5, unit: "mg", benefits: ["Heart health", "Longevity"])
                ]
            ),
            hydration: HydrationRecommendation(
                current: healthData.hydrationLevel.waterIntake,
                recommended: 3.0,
                additionalNeeds: max(0, 3.0 - healthData.hydrationLevel.waterIntake),
                timing: ["Upon waking", "Before meals", "During exercise", "Before bed"]
            ),
            timing: TimingRecommendation(
                mealTiming: [
                    MealTiming(meal: "Breakfast", time: "7:00 AM", priority: "High", focus: ["Protein", "Complex carbs"]),
                    MealTiming(meal: "Lunch", time: "12:30 PM", priority: "High", focus: ["Balanced macros", "Vegetables"]),
                    MealTiming(meal: "Dinner", time: "7:00 PM", priority: "Medium", focus: ["Protein", "Healthy fats"])
                ],
                preWorkout: healthData.activityData.exerciseMinutes > 30 ? "Banana + Almonds" : nil,
                postWorkout: healthData.activityData.exerciseMinutes > 30 ? "Protein shake + Berries" : nil,
                bedtime: healthData.sleepData.healthScore < 0.6 ? "Chamomile tea + Walnuts" : nil
            )
        )
    }
}

