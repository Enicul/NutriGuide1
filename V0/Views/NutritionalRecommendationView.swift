import SwiftUI

struct NutritionalRecommendationView: View {
    let recommendation: NutritionalRecommendation
    @State private var showingDetails = false
    
    var body: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                ERNIconView(ERNIcon.nutrition, color: .ernAccent, size: 24)
                Text("Nutritional Analysis")
                    .ernHeadline()
                Spacer()
                Button(showingDetails ? "Hide Details" : "Show Details") {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showingDetails.toggle()
                    }
                }
                .ernTertiary()
            }
            
            // Priority Nutrients
            PriorityNutrientsSection(priorities: recommendation.priorityNutrients)
            
            if showingDetails {
                // Macronutrients
                MacronutrientsSection(macros: recommendation.macronutrients)
                
                // Micronutrients
                MicronutrientsSection(micronutrients: recommendation.micronutrients)
                
                // Hydration
                HydrationSection(hydration: recommendation.hydration)
                
                // Timing Recommendations
                TimingSection(timing: recommendation.timing)
            }
        }
    }
}

struct PriorityNutrientsSection: View {
    let priorities: [PriorityNutrient]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Priority Nutrients")
                .ernTitle3()
                .foregroundColor(.ernTextPrimary)
            
            if priorities.isEmpty {
                Text("All nutrients are within optimal ranges")
                    .ernBody()
                    .foregroundColor(.ernTextSecondary)
                    .padding()
                    .background(Color.ernSuccess.opacity(0.1))
                    .cornerRadius(8)
            } else {
                ForEach(priorities) { priority in
                    PriorityNutrientCard(priority: priority)
                }
            }
        }
    }
}

struct PriorityNutrientCard: View {
    let priority: PriorityNutrient
    
    var body: some View {
        ERNCard {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(priority.nutrient)
                        .ernHeadline()
                        .foregroundColor(.ernTextPrimary)
                    
                    Spacer()
                    
                    PriorityBadge(priority: priority.priority)
                }
                
                Text(priority.reason)
                    .ernBody()
                    .foregroundColor(.ernTextSecondary)
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Current")
                            .ernCaption()
                            .foregroundColor(.ernTextTertiary)
                        Text("\(String(format: "%.1f", priority.currentIntake))")
                            .ernBodyEmphasized()
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .center, spacing: 4) {
                        Text("Deficit")
                            .ernCaption()
                            .foregroundColor(.ernTextTertiary)
                        Text("\(String(format: "%.1f", priority.recommendedIntake - priority.currentIntake))")
                            .ernBodyEmphasized()
                            .foregroundColor(.ernWarning)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Recommended")
                            .ernCaption()
                            .foregroundColor(.ernTextTertiary)
                        Text("\(String(format: "%.1f", priority.recommendedIntake))")
                            .ernBodyEmphasized()
                    }
                }
            }
        }
    }
}

struct PriorityBadge: View {
    let priority: PriorityNutrient.Priority
    
    var body: some View {
        Text(priority.rawValue)
            .ernCaption()
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(priorityColor)
            .cornerRadius(8)
    }
    
    private var priorityColor: Color {
        switch priority {
        case .high: return .ernError
        case .medium: return .ernWarning
        case .low: return .ernSuccess
        }
    }
}

struct MacronutrientsSection: View {
    let macros: MacronutrientRecommendation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Macronutrients")
                .ernTitle3()
                .foregroundColor(.ernTextPrimary)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                MacronutrientCard(
                    name: "Protein",
                    current: macros.protein.current,
                    recommended: macros.protein.recommended,
                    unit: macros.protein.unit,
                    color: .ernAccent
                )
                
                MacronutrientCard(
                    name: "Carbs",
                    current: macros.carbohydrates.current,
                    recommended: macros.carbohydrates.recommended,
                    unit: macros.carbohydrates.unit,
                    color: .ernSuccess
                )
                
                MacronutrientCard(
                    name: "Fat",
                    current: macros.fat.current,
                    recommended: macros.fat.recommended,
                    unit: macros.fat.unit,
                    color: .ernWarning
                )
                
                MacronutrientCard(
                    name: "Fiber",
                    current: macros.fiber.current,
                    recommended: macros.fiber.recommended,
                    unit: macros.fiber.unit,
                    color: .ernAccent
                )
            }
        }
    }
}

struct MacronutrientCard: View {
    let name: String
    let current: Double
    let recommended: Double
    let unit: String
    let color: Color
    
    var body: some View {
        ERNCard {
            VStack(alignment: .leading, spacing: 8) {
                Text(name)
                    .ernHeadline()
                    .foregroundColor(.ernTextPrimary)
                
                HStack {
                    Text("\(String(format: "%.1f", current))")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(color)
                    
                    Text("/ \(String(format: "%.1f", recommended)) \(unit)")
                        .ernCaption()
                        .foregroundColor(.ernTextSecondary)
                    
                    Spacer()
                }
                
                ProgressView(value: current, total: recommended)
                    .progressViewStyle(LinearProgressViewStyle(tint: color))
                
                if current < recommended * 0.8 {
                    Text("Needs more")
                        .ernCaption2()
                        .foregroundColor(.ernWarning)
                } else if current > recommended * 1.2 {
                    Text("Exceeds target")
                        .ernCaption2()
                        .foregroundColor(.ernError)
                } else {
                    Text("On track")
                        .ernCaption2()
                        .foregroundColor(.ernSuccess)
                }
            }
        }
    }
}

struct MicronutrientsSection: View {
    let micronutrients: MicronutrientRecommendation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Key Micronutrients")
                .ernTitle3()
                .foregroundColor(.ernTextPrimary)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(micronutrients.vitamins.prefix(4), id: \.name) { vitamin in
                    MicronutrientCard(
                        name: vitamin.name,
                        current: vitamin.current,
                        recommended: vitamin.recommended,
                        unit: vitamin.unit,
                        benefits: vitamin.benefits
                    )
                }
                
                ForEach(micronutrients.minerals.prefix(4), id: \.name) { mineral in
                    MicronutrientCard(
                        name: mineral.name,
                        current: mineral.current,
                        recommended: mineral.recommended,
                        unit: mineral.unit,
                        benefits: mineral.benefits
                    )
                }
            }
        }
    }
}

struct MicronutrientCard: View {
    let name: String
    let current: Double
    let recommended: Double
    let unit: String
    let benefits: [String]
    
    var body: some View {
        ERNCard {
            VStack(alignment: .leading, spacing: 6) {
                Text(name)
                    .ernHeadline()
                    .foregroundColor(.ernTextPrimary)
                
                HStack {
                    Text("\(String(format: "%.1f", current))")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(.ernAccent)
                    
                    Text("/ \(String(format: "%.1f", recommended)) \(unit)")
                        .ernCaption()
                        .foregroundColor(.ernTextSecondary)
                    
                    Spacer()
                }
                
                if !benefits.isEmpty {
                    Text(benefits.first ?? "")
                        .ernCaption2()
                        .foregroundColor(.ernTextTertiary)
                        .lineLimit(2)
                }
            }
        }
    }
}

struct HydrationSection: View {
    let hydration: HydrationRecommendation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Hydration")
                .ernTitle3()
                .foregroundColor(.ernTextPrimary)
            
            ERNCard {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        ERNIconView(ERNIcon.water, color: .ernAccent, size: 20)
                        Text("Water Intake")
                            .ernHeadline()
                        Spacer()
                    }
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Current")
                                .ernCaption()
                                .foregroundColor(.ernTextTertiary)
                            Text("\(String(format: "%.1f", hydration.current))L")
                                .ernBodyEmphasized()
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .center, spacing: 4) {
                            Text("Deficit")
                                .ernCaption()
                                .foregroundColor(.ernTextTertiary)
                            Text("\(String(format: "%.1f", hydration.deficit))L")
                                .ernBodyEmphasized()
                                .foregroundColor(.ernWarning)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("Target")
                                .ernCaption()
                                .foregroundColor(.ernTextTertiary)
                            Text("\(String(format: "%.1f", hydration.recommended))L")
                                .ernBodyEmphasized()
                        }
                    }
                    
                    ProgressView(value: hydration.current, total: hydration.recommended)
                        .progressViewStyle(LinearProgressViewStyle(tint: .ernAccent))
                    
                    if !hydration.timing.isEmpty {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Best times to drink:")
                                .ernCaption()
                                .foregroundColor(.ernTextSecondary)
                            Text(hydration.timing.joined(separator: " • "))
                                .ernCaption2()
                                .foregroundColor(.ernTextTertiary)
                        }
                    }
                }
            }
        }
    }
}

struct TimingSection: View {
    let timing: TimingRecommendation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Meal Timing")
                .ernTitle3()
                .foregroundColor(.ernTextPrimary)
            
            ForEach(timing.mealTiming, id: \.meal) { meal in
                ERNCard {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(meal.meal)
                                .ernHeadline()
                                .foregroundColor(.ernTextPrimary)
                            
                            Spacer()
                            
                            Text(meal.time)
                                .ernBody()
                                .foregroundColor(.ernAccent)
                        }
                        
                        HStack {
                            Text(meal.priority)
                                .ernCaption()
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(priorityColor(meal.priority))
                                .cornerRadius(6)
                            
                            Spacer()
                        }
                        
                        if !meal.focus.isEmpty {
                            Text("Focus: \(meal.focus.joined(separator: ", "))")
                                .ernCaption2()
                                .foregroundColor(.ernTextSecondary)
                        }
                    }
                }
            }
        }
    }
    
    private func priorityColor(_ priority: String) -> Color {
        switch priority.lowercased() {
        case "high": return .ernError
        case "medium": return .ernWarning
        default: return .ernSuccess
        }
    }
}

// MARK: - Preview
#Preview {
    ScrollView {
        NutritionalRecommendationView(recommendation: NutritionalRecommendation(
            timestamp: Date(),
            healthData: HealthData(
                timestamp: Date(),
                heartRateVariability: HeartRateVariability(rmssd: 45, sdnn: 65, pnn50: 15),
                sleepData: SleepData(
                    totalSleepTime: 7.5 * 3600,
                    deepSleepTime: 2 * 3600,
                    remSleepTime: 1.5 * 3600,
                    lightSleepTime: 4 * 3600,
                    sleepEfficiency: 85,
                    sleepOnsetTime: 15 * 60
                ),
                activityData: ActivityData(
                    steps: 8500,
                    activeMinutes: 120,
                    caloriesBurned: 2200,
                    exerciseMinutes: 45,
                    standingHours: 10
                ),
                stressLevel: StressLevel(
                    perceivedStress: 4,
                    cortisolLevel: 0.3,
                    heartRateResting: 62
                ),
                hydrationLevel: HydrationLevel(
                    waterIntake: 2.5,
                    urineColor: 3,
                    skinElasticity: 0.8
                )
            ),
            macronutrients: MacronutrientRecommendation(
                protein: NutrientIntake(current: 80, recommended: 120, unit: "g"),
                carbohydrates: NutrientIntake(current: 200, recommended: 300, unit: "g"),
                fat: NutrientIntake(current: 50, recommended: 80, unit: "g"),
                fiber: NutrientIntake(current: 15, recommended: 25, unit: "g")
            ),
            micronutrients: MicronutrientRecommendation(
                vitamins: [
                    VitaminRecommendation(name: "Vitamin D", current: 800, recommended: 2000, unit: "IU", benefits: ["Bone health", "Immune function"]),
                    VitaminRecommendation(name: "B12", current: 2.4, recommended: 2.4, unit: "mcg", benefits: ["Energy production", "Nerve function"])
                ],
                minerals: [
                    MineralRecommendation(name: "Magnesium", current: 200, recommended: 400, unit: "mg", benefits: ["Muscle function", "Stress relief"]),
                    MineralRecommendation(name: "Iron", current: 8, recommended: 18, unit: "mg", benefits: ["Oxygen transport", "Energy"])
                ],
                antioxidants: []
            ),
            hydration: HydrationRecommendation(
                current: 2.5,
                recommended: 3.0,
                additionalNeeds: 0.5,
                timing: ["Upon waking", "Before meals", "During exercise", "Before bed"]
            ),
            timing: TimingRecommendation(
                mealTiming: [
                    MealTiming(meal: "Breakfast", time: "7:00 AM", priority: "High", focus: ["Protein", "Complex carbs"]),
                    MealTiming(meal: "Lunch", time: "12:30 PM", priority: "High", focus: ["Balanced macros", "Vegetables"])
                ],
                preWorkout: "Banana + Almonds",
                postWorkout: "Protein shake + Berries",
                bedtime: "Chamomile tea + Walnuts"
            )
        ))
    }
    .padding()
    .background(Color.ernBackground)
}

