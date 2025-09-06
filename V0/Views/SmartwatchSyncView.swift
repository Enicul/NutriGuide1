import SwiftUI

struct SmartwatchSyncView: View {
    @StateObject private var healthDataService = HealthDataService()
    @StateObject private var nutritionalService = NutritionalRecommendationService()
    @StateObject private var nearbyFoodService = NearbyFoodService()
    @State private var currentStep: SyncStep = .syncing
    @State private var showingFoodRecommendations = false
    
    enum SyncStep {
        case syncing
        case analyzing
        case generating
        case complete
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 16) {
                    Text("Syncing from Smartwatch")
                        .ernTitle()
                        .foregroundColor(.ernTextPrimary)
                    
                    Text("Retrieving your latest health data and generating personalized recommendations")
                        .ernBody()
                        .foregroundColor(.ernTextSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding(.top, 40)
                .padding(.horizontal)
                
                Spacer()
                
                // Main content based on current step
                switch currentStep {
                case .syncing:
                    SyncingStepView()
                case .analyzing:
                    AnalyzingStepView()
                case .generating:
                    GeneratingStepView()
                case .complete:
                    CompleteStepView(
                        healthData: healthDataService.currentHealthData,
                        nutritionalRecommendation: nutritionalService.currentRecommendation,
                        onShowFoodRecommendations: {
                            showingFoodRecommendations = true
                        }
                    )
                }
                
                Spacer()
                
                // Action buttons
                if currentStep == .complete {
                    VStack(spacing: 12) {
                        Button("View Food Recommendations") {
                            showingFoodRecommendations = true
                        }
                        .ernPrimary()
                        .frame(maxWidth: .infinity)
                        
                        Button("Sync Again") {
                            startSyncProcess()
                        }
                        .ernSecondary()
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 40)
                }
            }
            .background(Color.ernBackground)
            .navigationBarHidden(true)
        }
        .onAppear {
            startSyncProcess()
        }
        .sheet(isPresented: $showingFoodRecommendations) {
            if let healthData = healthDataService.currentHealthData,
               let nutritionalRecommendation = nutritionalService.currentRecommendation {
                FoodRecommendationView(
                    healthData: healthData,
                    nutritionalRecommendation: nutritionalRecommendation,
                    nearbyFoodService: nearbyFoodService
                )
            }
        }
    }
    
    private func startSyncProcess() {
        currentStep = .syncing
        
        // Step 1: Sync health data
        healthDataService.syncHealthData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            currentStep = .analyzing
        }
        
        // Step 2: Generate nutritional recommendations
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            if let healthData = healthDataService.currentHealthData {
                nutritionalService.generateRecommendation(from: healthData)
            }
            currentStep = .generating
        }
        
        // Step 3: Search for nearby foods
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.5) {
            if let nutritionalRecommendation = nutritionalService.currentRecommendation {
                nearbyFoodService.searchNearbyFoods(for: nutritionalRecommendation)
            }
            currentStep = .complete
        }
    }
}

struct SyncingStepView: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 24) {
            // Animated smartwatch icon
            ZStack {
                Circle()
                    .stroke(Color.ernAccent.opacity(0.2), lineWidth: 4)
                    .frame(width: 120, height: 120)
                
                Circle()
                    .trim(from: 0, to: isAnimating ? 1 : 0)
                    .stroke(Color.ernAccent, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .frame(width: 120, height: 120)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 2), value: isAnimating)
                
                ERNIconView(ERNIcon.watch, color: .ernAccent, size: 40)
            }
            
            VStack(spacing: 8) {
                Text("Syncing Health Data")
                    .ernTitle3()
                    .foregroundColor(.ernTextPrimary)
                
                Text("Retrieving heart rate variability, sleep data, and activity levels from your smartwatch")
                    .ernBody()
                    .foregroundColor(.ernTextSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}

struct AnalyzingStepView: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 24) {
            // Animated brain icon
            ZStack {
                Circle()
                    .fill(Color.ernAccent.opacity(0.1))
                    .frame(width: 120, height: 120)
                
                ERNIconView(ERNIcon.brain, color: .ernAccent, size: 40)
                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: isAnimating)
            }
            
            VStack(spacing: 8) {
                Text("Analyzing Data")
                    .ernTitle3()
                    .foregroundColor(.ernTextPrimary)
                
                Text("Our AI engine is processing your health data through our nutrition science knowledge base")
                    .ernBody()
                    .foregroundColor(.ernTextSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}

struct GeneratingStepView: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 24) {
            // Animated nutrition icon
            ZStack {
                Circle()
                    .fill(Color.ernSuccess.opacity(0.1))
                    .frame(width: 120, height: 120)
                
                ERNIconView(ERNIcon.nutrition, color: .ernSuccess, size: 40)
                    .rotationEffect(.degrees(isAnimating ? 360 : 0))
                    .animation(.linear(duration: 2).repeatForever(autoreverses: false), value: isAnimating)
            }
            
            VStack(spacing: 8) {
                Text("Generating Recommendations")
                    .ernTitle3()
                    .foregroundColor(.ernTextPrimary)
                
                Text("Creating personalized nutrition recommendations and finding nearby food options")
                    .ernBody()
                    .foregroundColor(.ernTextSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}

struct CompleteStepView: View {
    let healthData: HealthData?
    let nutritionalRecommendation: NutritionalRecommendation?
    let onShowFoodRecommendations: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            // Success checkmark
            ZStack {
                Circle()
                    .fill(Color.ernSuccess.opacity(0.1))
                    .frame(width: 120, height: 120)
                
                ERNIconView(ERNIcon.checkmark, color: .ernSuccess, size: 40)
            }
            
            VStack(spacing: 12) {
                Text("Sync Complete!")
                    .ernTitle3()
                    .foregroundColor(.ernTextPrimary)
                
                Text("Your personalized nutrition recommendations are ready")
                    .ernBody()
                    .foregroundColor(.ernTextSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                if let healthData = healthData {
                    Text("Overall Health Score: \(Int(healthData.overallHealthScore * 100))/100")
                        .ernHeadline()
                        .foregroundColor(.ernAccent)
                }
            }
        }
    }
}

struct FoodRecommendationView: View {
    let healthData: HealthData
    let nutritionalRecommendation: NutritionalRecommendation
    @ObservedObject var nearbyFoodService: NearbyFoodService
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab: RecommendationTab = .foods
    
    enum RecommendationTab: String, CaseIterable {
        case health = "Health Data"
        case nutrition = "Nutrition"
        case foods = "Foods"
        case nearby = "Nearby"
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Tab picker
                Picker("Tab", selection: $selectedTab) {
                    ForEach(RecommendationTab.allCases, id: \.self) { tab in
                        Text(tab.rawValue).tag(tab)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                // Content based on selected tab
                ScrollView {
                    switch selectedTab {
                    case .health:
                        HealthDataCards(healthData: healthData)
                            .padding()
                    case .nutrition:
                        NutritionalRecommendationView(recommendation: nutritionalRecommendation)
                            .padding()
                    case .foods:
                        FoodRecommendationsView(recommendation: nutritionalRecommendation)
                            .padding()
                    case .nearby:
                        NearbyFoodView(nearbyFoodService: nearbyFoodService)
                            .padding()
                    }
                }
            }
            .background(Color.ernBackground)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .ernTertiary()
                }
            }
        }
    }
}

struct FoodRecommendationsView: View {
    let recommendation: NutritionalRecommendation
    
    var body: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                ERNIconView(ERNIcon.food, color: .ernAccent, size: 24)
                Text("Recommended Foods")
                    .ernHeadline()
                Spacer()
            }
            
            // Priority-based food recommendations
            VStack(spacing: 12) {
                ForEach(recommendation.priorityNutrients) { priority in
                    PriorityFoodSection(priority: priority)
                }
            }
        }
    }
}

struct PriorityFoodSection: View {
    let priority: PriorityNutrient
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Foods for \(priority.nutrient)")
                    .ernTitle3()
                    .foregroundColor(.ernTextPrimary)
                
                Spacer()
                
                PriorityBadge(priority: priority.priority)
            }
            
            // Mock food recommendations based on priority
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(getFoodsForNutrient(priority.nutrient), id: \.name) { food in
                    FoodTile(
                        food: food,
                        onEatThis: {
                            // TODO: Handle food selection
                        },
                        onShowAlternatives: {
                            // TODO: Show alternatives
                        }
                    )
                }
            }
        }
    }
    
    private func getFoodsForNutrient(_ nutrient: String) -> [Food] {
        // Mock food recommendations based on nutrient priority
        switch nutrient {
        case "Protein":
            return [
                Food(
                    name: "Grilled Chicken Breast",
                    emoji: "🍗",
                    nutrition: Nutrition(kcal: 165, carbs: 0, protein: 31, fat: 3.6, micros: ["Mg": 25, "B6": 0.5]),
                    tags: ["high-protein"],
                    portionText: "100g serving",
                    dietFlags: ["Gluten-Free", "Keto"],
                    allergyFlags: [],
                    rationale: "Complete protein source for muscle recovery and repair"
                ),
                Food(
                    name: "Greek Yogurt",
                    emoji: "🥛",
                    nutrition: Nutrition(kcal: 100, carbs: 6, protein: 17, fat: 0.4, micros: ["Ca": 200, "B12": 0.5]),
                    tags: ["high-protein", "probiotic"],
                    portionText: "170g container",
                    dietFlags: ["Vegetarian"],
                    allergyFlags: ["Dairy"],
                    rationale: "High protein with probiotics for gut health"
                )
            ]
        case "Magnesium":
            return [
                Food(
                    name: "Dark Chocolate (85%)",
                    emoji: "🍫",
                    nutrition: Nutrition(kcal: 170, carbs: 13, protein: 2.7, fat: 12, micros: ["Mg": 64, "Fe": 3.3]),
                    tags: ["antioxidant"],
                    portionText: "30g (3-4 pieces)",
                    dietFlags: ["Vegetarian"],
                    allergyFlags: ["Dairy (check label)"],
                    rationale: "Rich in magnesium and antioxidants for stress relief"
                ),
                Food(
                    name: "Almonds",
                    emoji: "🥜",
                    nutrition: Nutrition(kcal: 164, carbs: 6, protein: 6, fat: 14, micros: ["Mg": 76, "E": 7.3]),
                    tags: ["healthy-fats"],
                    portionText: "28g (23 almonds)",
                    dietFlags: ["Vegan", "Gluten-Free"],
                    allergyFlags: ["Nuts"],
                    rationale: "High magnesium content for muscle function and stress management"
                )
            ]
        case "Tryptophan":
            return [
                Food(
                    name: "Turkey Breast",
                    emoji: "🦃",
                    nutrition: Nutrition(kcal: 135, carbs: 0, protein: 25, fat: 3, micros: ["Tryptophan": 0.3, "B6": 0.6]),
                    tags: ["sleep-support"],
                    portionText: "100g serving",
                    dietFlags: ["Gluten-Free"],
                    allergyFlags: [],
                    rationale: "Rich in tryptophan for better sleep quality"
                ),
                Food(
                    name: "Oatmeal",
                    emoji: "🥣",
                    nutrition: Nutrition(kcal: 154, carbs: 27, protein: 5, fat: 3, micros: ["Tryptophan": 0.1, "Mg": 63]),
                    tags: ["complex-carbs"],
                    portionText: "40g dry (1/2 cup)",
                    dietFlags: ["Vegan", "Gluten-Free"],
                    allergyFlags: [],
                    rationale: "Complex carbs help tryptophan reach the brain for sleep"
                )
            ]
        case "Water":
            return [
                Food(
                    name: "Coconut Water",
                    emoji: "🥥",
                    nutrition: Nutrition(kcal: 19, carbs: 4, protein: 0.7, fat: 0.2, micros: ["K": 600, "Na": 252]),
                    tags: ["electrolytes"],
                    portionText: "240ml (1 cup)",
                    dietFlags: ["Vegan", "Gluten-Free"],
                    allergyFlags: [],
                    rationale: "Natural electrolytes for optimal hydration"
                ),
                Food(
                    name: "Watermelon",
                    emoji: "🍉",
                    nutrition: Nutrition(kcal: 30, carbs: 8, protein: 0.6, fat: 0.2, micros: ["Water": 92, "C": 8.1]),
                    tags: ["hydrating"],
                    portionText: "150g slice",
                    dietFlags: ["Vegan", "Gluten-Free"],
                    allergyFlags: [],
                    rationale: "92% water content with natural electrolytes"
                )
            ]
        default:
            return []
        }
    }
}

// MARK: - Preview
#Preview {
    SmartwatchSyncView()
}

