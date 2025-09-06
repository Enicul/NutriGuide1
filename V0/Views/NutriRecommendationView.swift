// This file is self-contained. Rename or integrate according to your project's conventions.

import SwiftUI

// MARK: - Protocol Definition
protocol NutritionalRecommendationViewModeling: ObservableObject {
    var recommendations: [NutritionalRecommendation] { get }
    var currentHealthState: HealthState { get }
    var selectedRecommendation: NutritionalRecommendation? { get set }
    var filterOptions: FilterOptions { get set }
    var sortOption: SortOption { get set }
    var showingFilters: Bool { get set }
    var isLoading: Bool { get }
    
    func loadRecommendations()
    func refreshRecommendations()
    func applyFilters()
    func markAsFavorite(_ recommendation: NutritionalRecommendation)
    func markAsCompleted(_ recommendation: NutritionalRecommendation)
}

// MARK: - Supporting Types
struct NutritionalRecommendation {
    let id = UUID()
    let food: MockFood
    let priority: Priority
    let reasoning: [String]
    let nutritionalBenefits: [NutritionalBenefit]
    let preparationTime: Int // minutes
    let difficulty: Difficulty
    let seasonality: Seasonality
    let availability: Availability
    let alternatives: [String]
    var isFavorite: Bool = false
    var isCompleted: Bool = false
    let recommendedTime: TimeOfDay
    let portionSize: String
    let caloriesPerPortion: Int
    
    enum Priority: String, CaseIterable {
        case high = "High"
        case medium = "Medium"
        case low = "Low"
        
        var color: Color {
            switch self {
            case .high: return .error
            case .medium: return .warning
            case .low: return .success
            }
        }
        
        var icon: String {
            switch self {
            case .high: return "exclamationmark.circle.fill"
            case .medium: return "minus.circle.fill"
            case .low: return "checkmark.circle.fill"
            }
        }
    }
    
    enum Difficulty: String, CaseIterable {
        case easy = "Easy"
        case moderate = "Moderate"
        case challenging = "Challenging"
        
        var color: Color {
            switch self {
            case .easy: return .success
            case .moderate: return .warning
            case .challenging: return .error
            }
        }
        
        var icon: String {
            switch self {
            case .easy: return "1.circle.fill"
            case .moderate: return "2.circle.fill"
            case .challenging: return "3.circle.fill"
            }
        }
    }
    
    enum Seasonality: String, CaseIterable {
        case year_round = "Year Round"
        case spring = "Spring"
        case summer = "Summer"
        case fall = "Fall"
        case winter = "Winter"
        
        var icon: String {
            switch self {
            case .year_round: return "calendar"
            case .spring: return "leaf.fill"
            case .summer: return "sun.max.fill"
            case .fall: return "leaf.arrow.circlepath"
            case .winter: return "snowflake"
            }
        }
        
        var color: Color {
            switch self {
            case .year_round: return .textSecondary
            case .spring: return .success
            case .summer: return .warning
            case .fall: return .stateStressed
            case .winter: return .stateSleepPrep
            }
        }
    }
    
    enum Availability: String, CaseIterable {
        case readily_available = "Readily Available"
        case specialty_store = "Specialty Store"
        case seasonal_limited = "Seasonal/Limited"
        case online_only = "Online Only"
        
        var color: Color {
            switch self {
            case .readily_available: return .success
            case .specialty_store: return .warning
            case .seasonal_limited: return .stateStressed
            case .online_only: return .info
            }
        }
    }
    
    enum TimeOfDay: String, CaseIterable {
        case breakfast = "Breakfast"
        case morning_snack = "Morning Snack"
        case lunch = "Lunch"
        case afternoon_snack = "Afternoon Snack"
        case dinner = "Dinner"
        case evening_snack = "Evening Snack"
        case anytime = "Anytime"
        
        var icon: String {
            switch self {
            case .breakfast: return "sunrise.fill"
            case .morning_snack: return "sun.min.fill"
            case .lunch: return "sun.max.fill"
            case .afternoon_snack: return "sun.and.horizon.fill"
            case .dinner: return "sunset.fill"
            case .evening_snack: return "moon.fill"
            case .anytime: return "clock.fill"
            }
        }
    }
}

struct NutritionalBenefit {
    let nutrient: String
    let benefit: String
    let amount: String
    let unit: String
    let percentDV: Int? // Percent Daily Value
    
    static let samples = [
        NutritionalBenefit(nutrient: "Vitamin C", benefit: "Immune support", amount: "90", unit: "mg", percentDV: 100),
        NutritionalBenefit(nutrient: "Fiber", benefit: "Digestive health", amount: "8", unit: "g", percentDV: 32),
        NutritionalBenefit(nutrient: "Protein", benefit: "Muscle recovery", amount: "25", unit: "g", percentDV: 50),
        NutritionalBenefit(nutrient: "Omega-3", benefit: "Brain health", amount: "2", unit: "g", percentDV: nil),
        NutritionalBenefit(nutrient: "Antioxidants", benefit: "Cell protection", amount: "High", unit: "", percentDV: nil)
    ]
}

struct FilterOptions {
    var priorityFilter: Set<NutritionalRecommendation.Priority> = Set(NutritionalRecommendation.Priority.allCases)
    var difficultyFilter: Set<NutritionalRecommendation.Difficulty> = Set(NutritionalRecommendation.Difficulty.allCases)
    var timeFilter: Set<NutritionalRecommendation.TimeOfDay> = Set(NutritionalRecommendation.TimeOfDay.allCases)
    var maxPreparationTime: Int = 60
    var showFavoritesOnly: Bool = false
    var showCompletedItems: Bool = true
    var availabilityFilter: Set<NutritionalRecommendation.Availability> = Set(NutritionalRecommendation.Availability.allCases)
}

enum SortOption: String, CaseIterable {
    case priority = "Priority"
    case preparationTime = "Prep Time"
    case difficulty = "Difficulty"
    case name = "Name"
    case calories = "Calories"
    
    var icon: String {
        switch self {
        case .priority: return "exclamationmark.circle"
        case .preparationTime: return "clock"
        case .difficulty: return "chart.bar"
        case .name: return "textformat.abc"
        case .calories: return "flame"
        }
    }
}

// MARK: - Mock ViewModel
class MockNutritionalRecommendationViewModel: NutritionalRecommendationViewModeling {
    @Published var recommendations: [NutritionalRecommendation] = []
    @Published var currentHealthState: HealthState = .calm
    @Published var selectedRecommendation: NutritionalRecommendation? = nil
    @Published var filterOptions = FilterOptions()
    @Published var sortOption: SortOption = .priority
    @Published var showingFilters = false
    @Published var isLoading = false
    
    init() {
        loadMockRecommendations()
    }
    
    private func loadMockRecommendations() {
        recommendations = [
            NutritionalRecommendation(
                food: MockFood.samples[0],
                priority: .high,
                reasoning: [
                    "Rich in antioxidants to support stress reduction",
                    "Natural sugars provide quick energy boost",
                    "Blueberries support cognitive function"
                ],
                nutritionalBenefits: Array(NutritionalBenefit.samples.prefix(3)),
                preparationTime: 5,
                difficulty: .easy,
                seasonality: .summer,
                availability: .readily_available,
                alternatives: ["Strawberry smoothie", "Mixed berry bowl", "Acai smoothie"],
                recommendedTime: .breakfast,
                portionSize: "1 cup (240ml)",
                caloriesPerPortion: 180
            ),
            NutritionalRecommendation(
                food: MockFood.samples[1],
                priority: .medium,
                reasoning: [
                    "High protein content supports muscle recovery",
                    "Probiotics improve digestive health",
                    "Low glycemic index prevents energy crashes"
                ],
                nutritionalBenefits: Array(NutritionalBenefit.samples.suffix(2)),
                preparationTime: 2,
                difficulty: .easy,
                seasonality: .year_round,
                availability: .readily_available,
                alternatives: ["Plain Greek yogurt", "Skyr with fruit", "Cottage cheese bowl"],
                recommendedTime: .morning_snack,
                portionSize: "3/4 cup (180g)",
                caloriesPerPortion: 150
            ),
            NutritionalRecommendation(
                food: MockFood.samples[2],
                priority: .medium,
                reasoning: [
                    "Healthy monounsaturated fats support heart health",
                    "High fiber content promotes satiety",
                    "Complex carbohydrates provide sustained energy"
                ],
                nutritionalBenefits: [
                    NutritionalBenefit.samples[1],
                    NutritionalBenefit.samples[3]
                ],
                preparationTime: 10,
                difficulty: .moderate,
                seasonality: .year_round,
                availability: .readily_available,
                alternatives: ["Hummus toast", "Nut butter toast", "Ricotta toast"],
                recommendedTime: .lunch,
                portionSize: "2 slices",
                caloriesPerPortion: 320
            )
        ]
    }
    
    func loadRecommendations() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.loadMockRecommendations()
            self.isLoading = false
        }
    }
    
    func refreshRecommendations() {
        loadRecommendations()
    }
    
    func applyFilters() {
        // Apply filtering logic
        loadMockRecommendations()
    }
    
    func markAsFavorite(_ recommendation: NutritionalRecommendation) {
        if let index = recommendations.firstIndex(where: { $0.id == recommendation.id }) {
            recommendations[index].isFavorite.toggle()
        }
    }
    
    func markAsCompleted(_ recommendation: NutritionalRecommendation) {
        if let index = recommendations.firstIndex(where: { $0.id == recommendation.id }) {
            recommendations[index].isCompleted.toggle()
        }
    }
}

// MARK: - Main Recommendation View
struct NutriRecommendationView<ViewModel: NutritionalRecommendationViewModeling>: View {
    @StateObject private var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Health State Header
                HealthStateHeaderView(state: viewModel.currentHealthState)
                    .padding(.horizontal)
                    .padding(.bottom)
                
                // Content
                if viewModel.isLoading {
                    Spacer()
                    ProgressView("Loading recommendations...")
                        .scaleEffect(1.2)
                    Spacer()
                } else if viewModel.recommendations.isEmpty {
                    EmptyRecommendationsView(onRefresh: viewModel.refreshRecommendations)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.recommendations, id: \.id) { recommendation in
                                RecommendationCardView(
                                    recommendation: recommendation,
                                    onFavorite: { viewModel.markAsFavorite(recommendation) },
                                    onComplete: { viewModel.markAsCompleted(recommendation) },
                                    onTap: { viewModel.selectedRecommendation = recommendation }
                                )
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 100)
                    }
                }
            }
            .background(Color.backgroundPrimary)
            .navigationTitle("Recommendations")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Menu {
                        ForEach(SortOption.allCases, id: \.self) { option in
                            Button {
                                viewModel.sortOption = option
                                viewModel.applyFilters()
                            } label: {
                                HStack {
                                    Image(systemName: option.icon)
                                    Text(option.rawValue)
                                    if viewModel.sortOption == option {
                                        Image(systemName: SystemIcon.checkmark)
                                    }
                                }
                            }
                        }
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                    }
                    .accessibility(label: Text("Sort options"))
                    
                    Button {
                        viewModel.showingFilters = true
                    } label: {
                        Image(systemName: SystemIcon.filter)
                    }
                    .accessibility(label: Text("Filter recommendations"))
                }
            }
            .refreshable {
                viewModel.refreshRecommendations()
            }
        }
        .sheet(item: $viewModel.selectedRecommendation) { recommendation in
            RecommendationDetailView(
                recommendation: recommendation,
                onFavorite: { viewModel.markAsFavorite(recommendation) },
                onComplete: { viewModel.markAsCompleted(recommendation) }
            )
        }
        .sheet(isPresented: $viewModel.showingFilters) {
            FilterView(
                filterOptions: $viewModel.filterOptions,
                onApply: {
                    viewModel.applyFilters()
                    viewModel.showingFilters = false
                }
            )
        }
    }
}

// MARK: - Health State Header
struct HealthStateHeaderView: View {
    let state: HealthState
    
    var body: some View {
        NutriCard {
            HStack(spacing: 16) {
                Image(systemName: state.icon)
                    .font(.title)
                    .foregroundColor(state.color)
                    .frame(width: 40, height: 40)
                    .background(state.color.opacity(0.2))
                    .cornerRadius(20)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Optimized for your current state")
                        .caption()
                        .foregroundColor(.textSecondary)
                    
                    Text(state.title)
                        .headline()
                        .foregroundColor(.textPrimary)
                    
                    Text(state.description)
                        .body()
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
            }
            .padding(16)
        }
    }
}

// MARK: - Recommendation Card
struct RecommendationCardView: View {
    let recommendation: NutritionalRecommendation
    let onFavorite: () -> Void
    let onComplete: () -> Void
    let onTap: () -> Void
    
    var body: some View {
        NutriCard {
            VStack(alignment: .leading, spacing: 16) {
                // Header with food info and actions
                HStack {
                    HStack(spacing: 12) {
                        Image(systemName: recommendation.food.imageSystemName)
                            .font(.title)
                            .foregroundColor(.accentPrimary)
                            .frame(width: 44, height: 44)
                            .background(Color.accentPrimary.opacity(0.1))
                            .cornerRadius(22)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(recommendation.food.name)
                                .headline()
                                .foregroundColor(.textPrimary)
                            
                            Text(recommendation.food.category)
                                .caption()
                                .foregroundColor(.textSecondary)
                        }
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 8) {
                        Button(action: onFavorite) {
                            Image(systemName: recommendation.isFavorite ? "heart.fill" : "heart")
                                .font(.title3)
                                .foregroundColor(recommendation.isFavorite ? .error : .textSecondary)
                        }
                        .accessibility(label: Text(recommendation.isFavorite ? "Remove from favorites" : "Add to favorites"))
                        
                        Button(action: onComplete) {
                            Image(systemName: recommendation.isCompleted ? SystemIcon.checkmark : "circle")
                                .font(.title3)
                                .foregroundColor(recommendation.isCompleted ? .success : .textSecondary)
                        }
                        .accessibility(label: Text(recommendation.isCompleted ? "Mark as incomplete" : "Mark as complete"))
                    }
                }
                
                // Priority and timing tags
                HStack(spacing: 8) {
                    HStack(spacing: 4) {
                        Image(systemName: recommendation.priority.icon)
                            .font(.caption)
                        Text(recommendation.priority.rawValue)
                            .caption()
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(recommendation.priority.color.opacity(0.2))
                    .foregroundColor(recommendation.priority.color)
                    .cornerRadius(8)
                    
                    HStack(spacing: 4) {
                        Image(systemName: recommendation.recommendedTime.icon)
                            .font(.caption)
                        Text(recommendation.recommendedTime.rawValue)
                            .caption()
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.backgroundTertiary)
                    .foregroundColor(.textSecondary)
                    .cornerRadius(8)
                    
                    Spacer()
                }
                
                // Quick nutrition info
                HStack(spacing: 12) {
                    NutritionBadge(
                        nutrient: "Cal",
                        value: "\(recommendation.caloriesPerPortion)",
                        color: .accentPrimary
                    )
                    
                    NutritionBadge(
                        nutrient: "Time",
                        value: "\(recommendation.preparationTime)min",
                        color: .textSecondary
                    )
                    
                    NutritionBadge(
                        nutrient: "Difficulty",
                        value: recommendation.difficulty.rawValue,
                        color: recommendation.difficulty.color
                    )
                    
                    Spacer()
                }
                
                // Top reasoning
                if let firstReason = recommendation.reasoning.first {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Why this helps:")
                            .caption()
                            .foregroundColor(.textSecondary)
                        
                        Text(firstReason)
                            .body()
                            .foregroundColor(.textPrimary)
                            .lineLimit(2)
                    }
                    .padding(.top, 4)
                }
                
                // Availability indicator
                HStack {
                    Circle()
                        .fill(recommendation.availability.color)
                        .frame(width: 8, height: 8)
                    
                    Text(recommendation.availability.rawValue)
                        .caption()
                        .foregroundColor(.textSecondary)
                    
                    Spacer()
                    
                    Button("View Details") {
                        onTap()
                    }
                    .buttonStyle(TertiaryButtonStyle())
                    .font(.caption)
                }
            }
            .padding(16)
        }
        .accessibility(label: Text("\(recommendation.food.name) recommendation"))
        .accessibility(hint: Text("Tap for detailed information"))
    }
}

// MARK: - Empty State
struct EmptyRecommendationsView: View {
    let onRefresh: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "fork.knife.circle")
                .font(.system(size: 64))
                .foregroundColor(.textTertiary)
            
            VStack(spacing: 8) {
                Text("No Recommendations Yet")
                    .title2()
                    .foregroundColor(.textPrimary)
                
                Text("We're analyzing your health data to provide personalized food recommendations.")
                    .body()
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            Button("Refresh") {
                onRefresh()
            }
            .buttonStyle(PrimaryButtonStyle())
            .padding(.horizontal, 80)
            
            Spacer()
        }
    }
}

// MARK: - Filter View
struct FilterView: View {
    @Binding var filterOptions: FilterOptions
    let onApply: () -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Priority") {
                    ForEach(NutritionalRecommendation.Priority.allCases, id: \.self) { priority in
                        HStack {
                            Image(systemName: priority.icon)
                                .foregroundColor(priority.color)
                            Text(priority.rawValue)
                            Spacer()
                            if filterOptions.priorityFilter.contains(priority) {
                                Image(systemName: SystemIcon.checkmark)
                                    .foregroundColor(.accentPrimary)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if filterOptions.priorityFilter.contains(priority) {
                                filterOptions.priorityFilter.remove(priority)
                            } else {
                                filterOptions.priorityFilter.insert(priority)
                            }
                        }
                    }
                }
                
                Section("Meal Time") {
                    ForEach(NutritionalRecommendation.TimeOfDay.allCases, id: \.self) { time in
                        HStack {
                            Image(systemName: time.icon)
                                .foregroundColor(.accentPrimary)
                            Text(time.rawValue)
                            Spacer()
                            if filterOptions.timeFilter.contains(time) {
                                Image(systemName: SystemIcon.checkmark)
                                    .foregroundColor(.accentPrimary)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if filterOptions.timeFilter.contains(time) {
                                filterOptions.timeFilter.remove(time)
                            } else {
                                filterOptions.timeFilter.insert(time)
                            }
                        }
                    }
                }
                
                Section("Preparation Time") {
                    HStack {
                        Text("Max: \(filterOptions.maxPreparationTime) minutes")
                        Spacer()
                    }
                    
                    Slider(
                        value: Binding(
                            get: { Double(filterOptions.maxPreparationTime) },
                            set: { filterOptions.maxPreparationTime = Int($0) }
                        ),
                        in: 5...120,
                        step: 5
                    )
                }
                
                Section("Display Options") {
                    Toggle("Favorites Only", isOn: $filterOptions.showFavoritesOnly)
                    Toggle("Show Completed Items", isOn: $filterOptions.showCompletedItems)
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Reset") {
                        filterOptions = FilterOptions()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Apply") {
                        onApply()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}

// MARK: - Recommendation Detail View
struct RecommendationDetailView: View {
    let recommendation: NutritionalRecommendation
    let onFavorite: () -> Void
    let onComplete: () -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Hero section
                    RecommendationHeroView(recommendation: recommendation)
                    
                    // Nutritional benefits
                    NutritionalBenefitsSection(benefits: recommendation.nutritionalBenefits)
                    
                    // Reasoning
                    ReasoningSection(reasoning: recommendation.reasoning)
                    
                    // Details
                    RecommendationDetailsSection(recommendation: recommendation)
                    
                    // Alternatives
                    AlternativesSection(alternatives: recommendation.alternatives)
                    
                    Spacer(minLength: 40)
                }
                .padding()
            }
            .background(Color.backgroundPrimary)
            .navigationTitle(recommendation.food.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
                
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: onFavorite) {
                        Image(systemName: recommendation.isFavorite ? "heart.fill" : "heart")
                            .foregroundColor(recommendation.isFavorite ? .error : .textSecondary)
                    }
                    
                    Button(action: onComplete) {
                        Image(systemName: recommendation.isCompleted ? SystemIcon.checkmark : "circle")
                            .foregroundColor(recommendation.isCompleted ? .success : .textSecondary)
                    }
                }
            }
        }
    }
}

// MARK: - Detail View Components
struct RecommendationHeroView: View {
    let recommendation: NutritionalRecommendation
    
    var body: some View {
        NutriCard {
            VStack(spacing: 16) {
                Image(systemName: recommendation.food.imageSystemName)
                    .font(.system(size: 48))
                    .foregroundColor(.accentPrimary)
                    .frame(width: 80, height: 80)
                    .background(Color.accentPrimary.opacity(0.1))
                    .cornerRadius(40)
                
                VStack(spacing: 8) {
                    Text(recommendation.food.name)
                        .title()
                        .foregroundColor(.textPrimary)
                        .multilineTextAlignment(.center)
                    
                    Text(recommendation.food.category)
                        .subheadline()
                        .foregroundColor(.textSecondary)
                }
                
                HStack(spacing: 16) {
                    HStack(spacing: 4) {
                        Image(systemName: recommendation.priority.icon)
                        Text(recommendation.priority.rawValue)
                    }
                    .foregroundColor(recommendation.priority.color)
                    
                    Text("•")
                        .foregroundColor(.textTertiary)
                    
                    HStack(spacing: 4) {
                        Image(systemName: SystemIcon.clock)
                        Text("\(recommendation.preparationTime) min")
                    }
                    .foregroundColor(.textSecondary)
                    
                    Text("•")
                        .foregroundColor(.textTertiary)
                    
                    HStack(spacing: 4) {
                        Image(systemName: recommendation.difficulty.icon)
                        Text(recommendation.difficulty.rawValue)
                    }
                    .foregroundColor(recommendation.difficulty.color)
                }
                .font(.caption)
            }
            .padding(20)
        }
    }
}

struct NutritionalBenefitsSection: View {
    let benefits: [NutritionalBenefit]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Nutritional Benefits")
                .headline()
                .foregroundColor(.textPrimary)
            
            VStack(spacing: 12) {
                ForEach(benefits, id: \.nutrient) { benefit in
                    NutritionalBenefitCard(benefit: benefit)
                }
            }
        }
    }
}

struct NutritionalBenefitCard: View {
    let benefit: NutritionalBenefit
    
    var body: some View {
        NutriCard {
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(benefit.nutrient)
                        .headline()
                        .foregroundColor(.textPrimary)
                    
                    Text(benefit.benefit)
                        .body()
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    HStack(spacing: 2) {
                        Text(benefit.amount)
                            .headline()
                            .foregroundColor(.accentPrimary)
                        
                        if !benefit.unit.isEmpty {
                            Text(benefit.unit)
                                .caption()
                                .foregroundColor(.textSecondary)
                        }
                    }
                    
                    if let percentDV = benefit.percentDV {
                        Text("\(percentDV)% DV")
                            .caption()
                            .foregroundColor(.textSecondary)
                    }
                }
            }
            .padding(16)
        }
    }
}

struct ReasoningSection: View {
    let reasoning: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Why This Recommendation")
                .headline()
                .foregroundColor(.textPrimary)
            
            VStack(spacing: 12) {
                ForEach(Array(reasoning.enumerated()), id: \.offset) { index, reason in
                    HStack(alignment: .top, spacing: 12) {
                        Text("\(index + 1)")
                            .caption()
                            .fontWeight(.semibold)
                            .foregroundColor(.accentPrimary)
                            .frame(width: 24, height: 24)
                            .background(Color.accentPrimary.opacity(0.1))
                            .cornerRadius(12)
                        
                        Text(reason)
                            .body()
                            .foregroundColor(.textPrimary)
                        
                        Spacer()
                    }
                }
            }
        }
    }
}

struct RecommendationDetailsSection: View {
    let recommendation: NutritionalRecommendation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Details")
                .headline()
                .foregroundColor(.textPrimary)
            
            NutriCard {
                VStack(spacing: 16) {
                    DetailRow(icon: "chart.pie", title: "Portion Size", value: recommendation.portionSize)
                    DetailRow(icon: "flame", title: "Calories", value: "\(recommendation.caloriesPerPortion)")
                    DetailRow(icon: recommendation.recommendedTime.icon, title: "Best Time", value: recommendation.recommendedTime.rawValue)
                    DetailRow(icon: recommendation.seasonality.icon, title: "Seasonality", value: recommendation.seasonality.rawValue)
                    DetailRow(icon: "location", title: "Availability", value: recommendation.availability.rawValue)
                }
                .padding(16)
            }
        }
    }
}

struct DetailRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.accentPrimary)
                .frame(width: 24)
            
            Text(title)
                .body()
                .foregroundColor(.textSecondary)
            
            Spacer()
            
            Text(value)
                .body()
                .foregroundColor(.textPrimary)
                .fontWeight(.medium)
        }
    }
}

struct AlternativesSection: View {
    let alternatives: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Similar Options")
                .headline()
                .foregroundColor(.textPrimary)
            
            VStack(spacing: 8) {
                ForEach(alternatives, id: \.self) { alternative in
                    HStack {
                        Image(systemName: "arrow.right.circle")
                            .font(.title3)
                            .foregroundColor(.accentPrimary)
                        
                        Text(alternative)
                            .body()
                            .foregroundColor(.textPrimary)
                        
                        Spacer()
                    }
                    .padding(.vertical, 4)
                }
            }
        }
    }
}

// MARK: - Preview
struct NutriRecommendationView_Previews: PreviewProvider {
    static var previews: some View {
        DevicePreview {
            NutriRecommendationView(viewModel: MockNutritionalRecommendationViewModel())
        }
        .previewDevice("iPhone 15 Pro")
    }
}
