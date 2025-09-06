// This file is self-contained. Rename or integrate according to your project's conventions.

import SwiftUI

// MARK: - Protocol Definition
protocol HomeViewModeling: ObservableObject {
    var currentHealthState: HealthState { get }
    var recommendedFoods: [MockFood] { get }
    var healthMetrics: [MockHealthMetric] { get }
    var isLoading: Bool { get }
    var showingRecommendationDetails: Bool { get set }
    var showingSnoozeOptions: Bool { get set }
    var showingWhyExplanation: Bool { get set }
    
    func refreshRecommendations()
    func cycleHealthState()
    func snoozeRecommendations(for minutes: Int)
    func dismissSnooze()
    func showWhyExplanation()
    func dismissWhyExplanation()
}

// MARK: - Mock ViewModel
class MockHomeViewModel: HomeViewModeling {
    @Published var currentHealthState: HealthState = .calm
    @Published var recommendedFoods: [MockFood] = MockFood.samples
    @Published var healthMetrics: [MockHealthMetric] = MockHealthMetric.samples
    @Published var isLoading: Bool = false
    @Published var showingRecommendationDetails: Bool = false
    @Published var showingSnoozeOptions: Bool = false
    @Published var showingWhyExplanation: Bool = false
    
    private var stateIndex = 0
    
    func refreshRecommendations() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isLoading = false
        }
    }
    
    func cycleHealthState() {
        let states = HealthState.allCases
        stateIndex = (stateIndex + 1) % states.count
        currentHealthState = states[stateIndex]
    }
    
    func snoozeRecommendations(for minutes: Int) {
        showingSnoozeOptions = false
        // Snooze logic would go here
    }
    
    func dismissSnooze() {
        showingSnoozeOptions = false
    }
    
    func showWhyExplanation() {
        showingWhyExplanation = true
    }
    
    func dismissWhyExplanation() {
        showingWhyExplanation = false
    }
}

// MARK: - Main Home View
struct NutriHomeView<ViewModel: HomeViewModeling>: View {
    @StateObject private var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // App Header
                    AppHeaderView()
                    
                    // Current Health State Card
                    HealthStateCardView(
                        state: viewModel.currentHealthState,
                        onRefresh: viewModel.refreshRecommendations,
                        onCycleState: viewModel.cycleHealthState
                    )
                    .padding(.horizontal)
                    
                    // Quick Health Metrics
                    QuickHealthMetricsView(metrics: viewModel.healthMetrics)
                        .padding(.horizontal)
                    
                    // Recommended Foods Section
                    RecommendedFoodsSection(
                        foods: viewModel.recommendedFoods,
                        isLoading: viewModel.isLoading,
                        onShowDetails: { viewModel.showingRecommendationDetails = true },
                        onShowWhy: viewModel.showWhyExplanation
                    )
                    .padding(.horizontal)
                    
                    // Action Buttons
                    ActionButtonsView(
                        onSnooze: { viewModel.showingSnoozeOptions = true },
                        onSync: {
                            // Navigation to sync view would go here
                        }
                    )
                    .padding(.horizontal)
                    
                    Spacer(minLength: 100)
                }
                .padding(.top, 20)
            }
            .background(Color.backgroundPrimary)
            .navigationBarHidden(true)
            .refreshable {
                viewModel.refreshRecommendations()
            }
        }
        .sheet(isPresented: $viewModel.showingSnoozeOptions) {
            SnoozeOptionsSheet(
                onSnooze: viewModel.snoozeRecommendations,
                onDismiss: viewModel.dismissSnooze
            )
        }
        .sheet(isPresented: $viewModel.showingWhyExplanation) {
            WhyRecommendationSheet(
                state: viewModel.currentHealthState,
                foods: viewModel.recommendedFoods,
                onDismiss: viewModel.dismissWhyExplanation
            )
        }
    }
}

// MARK: - App Header
struct AppHeaderView: View {
    var body: some View {
        VStack(spacing: 8) {
            Text("NutriGuide")
                .largeTitle()
                .foregroundColor(.accentPrimary)
            
            Text("Personalized nutrition based on your current state")
                .subheadline()
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }
}

// MARK: - Health State Card
struct HealthStateCardView: View {
    let state: HealthState
    let onRefresh: () -> Void
    let onCycleState: () -> Void
    
    var body: some View {
        NutriCard(shadowLevel: 2) {
            VStack(spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Current State")
                            .caption()
                            .foregroundColor(.textSecondary)
                        
                        Text(state.title)
                            .title2()
                            .foregroundColor(.textPrimary)
                    }
                    
                    Spacer()
                    
                    Button(action: onRefresh) {
                        Image(systemName: SystemIcon.refresh)
                            .font(.title3)
                            .foregroundColor(.accentPrimary)
                    }
                    .accessibility(label: Text("Refresh recommendations"))
                    .accessibility(hint: Text("Double tap to refresh food recommendations"))
                }
                
                HStack(spacing: 12) {
                    Image(systemName: state.icon)
                        .font(.title)
                        .foregroundColor(state.color)
                        .frame(width: 40, height: 40)
                        .background(state.color.opacity(0.2))
                        .cornerRadius(20)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(state.description)
                            .body()
                            .foregroundColor(.textPrimary)
                        
                        HealthStateTag(state: state)
                    }
                    
                    Spacer()
                }
                
                // Test button (remove in production)
                Button("Cycle State (Test)") {
                    onCycleState()
                }
                .buttonStyle(TertiaryButtonStyle())
                .font(.caption)
            }
            .padding(20)
        }
    }
}

// MARK: - Quick Health Metrics
struct QuickHealthMetricsView: View {
    let metrics: [MockHealthMetric]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Health Overview")
                .headline()
                .foregroundColor(.textPrimary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(metrics, id: \.name) { metric in
                    HealthMetricCard(metric: metric)
                }
            }
        }
    }
}

struct HealthMetricCard: View {
    let metric: MockHealthMetric
    
    var body: some View {
        NutriCard {
            VStack(spacing: 8) {
                HStack {
                    Image(systemName: metric.icon)
                        .font(.title3)
                        .foregroundColor(metric.color)
                    
                    Spacer()
                    
                    Image(systemName: metric.trend.icon)
                        .font(.caption)
                        .foregroundColor(metric.trend == .up ? .success : metric.trend == .down ? .error : .textSecondary)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text(metric.value)
                            .headline()
                            .foregroundColor(.textPrimary)
                        
                        Text(metric.unit)
                            .caption()
                            .foregroundColor(.textSecondary)
                        
                        Spacer()
                    }
                    
                    Text(metric.name)
                        .caption()
                        .foregroundColor(.textSecondary)
                }
            }
            .padding(16)
        }
        .accessibility(label: Text("\(metric.name): \(metric.value) \(metric.unit)"))
    }
}

// MARK: - Recommended Foods Section
struct RecommendedFoodsSection: View {
    let foods: [MockFood]
    let isLoading: Bool
    let onShowDetails: () -> Void
    let onShowWhy: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Recommended for You")
                    .headline()
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Button("Why?") {
                    onShowWhy()
                }
                .buttonStyle(TertiaryButtonStyle())
                .font(.caption)
                .accessibility(label: Text("Why these recommendations"))
                .accessibility(hint: Text("Learn why these foods are recommended for your current state"))
            }
            
            if isLoading {
                HStack {
                    Spacer()
                    ProgressView()
                        .scaleEffect(1.2)
                    Spacer()
                }
                .frame(height: 120)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(foods, id: \.id) { food in
                            FoodRecommendationCard(food: food)
                        }
                    }
                    .padding(.horizontal, 1)
                }
            }
        }
    }
}

struct FoodRecommendationCard: View {
    let food: MockFood
    
    var body: some View {
        NutriCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: food.imageSystemName)
                        .font(.largeTitle)
                        .foregroundColor(.accentPrimary)
                        .frame(width: 50, height: 50)
                        .background(Color.accentPrimary.opacity(0.1))
                        .cornerRadius(25)
                    
                    Spacer()
                    
                    if food.isAvailableNearby {
                        HStack(spacing: 4) {
                            Image(systemName: SystemIcon.location)
                                .font(.caption)
                            Text("Nearby")
                                .caption()
                        }
                        .foregroundColor(.success)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.success.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(food.name)
                        .headline()
                        .foregroundColor(.textPrimary)
                    
                    Text(food.category)
                        .caption()
                        .foregroundColor(.textSecondary)
                }
                
                HStack(spacing: 8) {
                    NutritionBadge(
                        nutrient: "Cal",
                        value: "\(food.nutrition.calories)",
                        color: .accentPrimary
                    )
                    
                    NutritionBadge(
                        nutrient: "Protein",
                        value: "\(food.nutrition.protein)g",
                        color: .nutritionProtein
                    )
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Benefits")
                        .caption()
                        .foregroundColor(.textSecondary)
                    
                    HStack {
                        ForEach(Array(food.benefits.prefix(2)), id: \.self) { benefit in
                            Text(benefit)
                                .caption2()
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.backgroundTertiary)
                                .cornerRadius(4)
                        }
                        
                        if food.benefits.count > 2 {
                            Text("+\(food.benefits.count - 2)")
                                .caption2()
                                .foregroundColor(.textSecondary)
                        }
                    }
                }
                
                HStack {
                    Image(systemName: SystemIcon.clock)
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                    
                    Text(food.estimatedTime)
                        .caption()
                        .foregroundColor(.textSecondary)
                    
                    Spacer()
                }
            }
            .padding(16)
        }
        .frame(width: 220)
        .accessibility(label: Text("\(food.name), \(food.category), \(food.nutrition.calories) calories"))
        .accessibility(hint: Text("Tap for more details"))
    }
}

// MARK: - Action Buttons
struct ActionButtonsView: View {
    let onSnooze: () -> Void
    let onSync: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            Button("Sync from Apple Watch") {
                onSync()
            }
            .buttonStyle(PrimaryButtonStyle())
            .accessibility(label: Text("Sync health data from Apple Watch"))
            .accessibility(hint: Text("Update recommendations with latest health data"))
            
            Button("Snooze Recommendations") {
                onSnooze()
            }
            .buttonStyle(SecondaryButtonStyle())
            .accessibility(label: Text("Snooze recommendations"))
            .accessibility(hint: Text("Temporarily pause food recommendations"))
        }
    }
}

// MARK: - Snooze Options Sheet
struct SnoozeOptionsSheet: View {
    let onSnooze: (Int) -> Void
    let onDismiss: () -> Void
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                VStack(spacing: 12) {
                    Text("Snooze Recommendations")
                        .title2()
                        .foregroundColor(.textPrimary)
                    
                    Text("Temporarily pause food recommendations")
                        .body()
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top)
                
                VStack(spacing: 16) {
                    SnoozeOptionButton(
                        title: "30 minutes",
                        subtitle: "Short break",
                        icon: SystemIcon.clock,
                        action: { onSnooze(30) }
                    )
                    
                    SnoozeOptionButton(
                        title: "1 hour",
                        subtitle: "Focus time",
                        icon: SystemIcon.focus,
                        action: { onSnooze(60) }
                    )
                    
                    SnoozeOptionButton(
                        title: "2 hours",
                        subtitle: "Extended focus",
                        icon: SystemIcon.focus,
                        action: { onSnooze(120) }
                    )
                    
                    SnoozeOptionButton(
                        title: "Until tomorrow",
                        subtitle: "Full day break",
                        icon: SystemIcon.sleep,
                        action: { onSnooze(1440) }
                    )
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .background(Color.backgroundPrimary)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        onDismiss()
                    }
                    .buttonStyle(TertiaryButtonStyle())
                }
            }
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
}

struct SnoozeOptionButton: View {
    let title: String
    let subtitle: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.accentPrimary)
                    .frame(width: 32, height: 32)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .headline()
                        .foregroundColor(.textPrimary)
                    
                    Text(subtitle)
                        .caption()
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.textTertiary)
            }
            .padding(16)
            .background(Color.backgroundCard)
            .cornerRadius(12)
            .frame(minHeight: 44)
        }
        .buttonStyle(PlainButtonStyle())
        .accessibility(label: Text("Snooze for \(title)"))
    }
}

// MARK: - Why Recommendation Sheet
struct WhyRecommendationSheet: View {
    let state: HealthState
    let foods: [MockFood]
    let onDismiss: () -> Void
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Why These Recommendations?")
                            .title2()
                            .foregroundColor(.textPrimary)
                        
                        Text("Based on your current \(state.title.lowercased()) state, we've selected foods that can help:")
                            .body()
                            .foregroundColor(.textSecondary)
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        WhyReasonCard(
                            icon: SystemIcon.heart,
                            title: "Scientific Basis",
                            description: "Recommendations based on nutritional science and physiological research"
                        )
                        
                        WhyReasonCard(
                            icon: SystemIcon.stress,
                            title: "State-Specific",
                            description: "Foods selected to address your current \(state.title.lowercased()) state"
                        )
                        
                        WhyReasonCard(
                            icon: SystemIcon.nutrition,
                            title: "Nutritional Balance",
                            description: "Optimized macro and micronutrient profiles for your needs"
                        )
                        
                        WhyReasonCard(
                            icon: SystemIcon.clock,
                            title: "Timing Matters",
                            description: "Recommendations consider optimal timing for nutrient absorption"
                        )
                    }
                    
                    Spacer(minLength: 40)
                }
                .padding()
            }
            .background(Color.backgroundPrimary)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        onDismiss()
                    }
                    .buttonStyle(TertiaryButtonStyle())
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}

struct WhyReasonCard: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.accentPrimary)
                .frame(width: 32, height: 32)
                .background(Color.accentPrimary.opacity(0.1))
                .cornerRadius(16)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .headline()
                    .foregroundColor(.textPrimary)
                
                Text(description)
                    .body()
                    .foregroundColor(.textSecondary)
            }
        }
    }
}

// MARK: - Preview
struct NutriHomeView_Previews: PreviewProvider {
    static var previews: some View {
        DevicePreview {
            NutriHomeView(viewModel: MockHomeViewModel())
        }
        .previewDevice("iPhone 15 Pro")
    }
}
