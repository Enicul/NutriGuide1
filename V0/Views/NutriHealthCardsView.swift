// This file is self-contained. Rename or integrate according to your project's conventions.

import SwiftUI
import HealthKit

// MARK: - Protocol Definition
protocol HealthCardsViewModeling: ObservableObject {
    var healthCards: [HealthCard] { get }
    var selectedCard: HealthCard? { get set }
    var selectedTimeRange: TimeRange { get set }
    var isLoading: Bool { get }
    var lastUpdateTime: Date? { get }
    
    func refreshHealthData()
    func loadDetailedData(for card: HealthCard)
    func exportHealthData()
    func shareHealthInsights()
}

// MARK: - Supporting Types
struct HealthCard {
    let id = UUID()
    let type: HealthCardType
    let currentValue: String
    let unit: String
    let trend: TrendDirection
    let trendPercentage: Double
    let chartData: [HealthDataPoint]
    let insights: [String]
    let recommendations: [String]
    let lastUpdated: Date
    let isAvailable: Bool
    let targetRange: TargetRange?
    
    enum HealthCardType: String, CaseIterable {
        case heartRate = "Heart Rate"
        case steps = "Steps"
        case activeCalories = "Active Calories"
        case sleep = "Sleep"
        case stress = "Stress Level"
        case bloodOxygen = "Blood Oxygen"
        case hrv = "Heart Rate Variability"
        case restingHeartRate = "Resting Heart Rate"
        case workout = "Workout Time"
        case hydration = "Hydration"
        case weight = "Weight"
        case bodyFat = "Body Fat"
        
        var icon: String {
            switch self {
            case .heartRate, .restingHeartRate: return "heart.fill"
            case .steps: return "figure.walk"
            case .activeCalories: return "flame.fill"
            case .sleep: return "moon.fill"
            case .stress: return "brain.head.profile"
            case .bloodOxygen: return "lungs.fill"
            case .hrv: return "waveform.path.ecg"
            case .workout: return "figure.run"
            case .hydration: return "drop.fill"
            case .weight: return "scalemass.fill"
            case .bodyFat: return "percent"
            }
        }
        
        var color: Color {
            switch self {
            case .heartRate, .restingHeartRate: return .error
            case .steps: return .success
            case .activeCalories: return .warning
            case .sleep: return .stateSleepPrep
            case .stress: return .stateStressed
            case .bloodOxygen: return .info
            case .hrv: return .accentPrimary
            case .workout: return .statePostWorkout
            case .hydration: return .info
            case .weight: return .textSecondary
            case .bodyFat: return .stateStressed
            }
        }
        
        var description: String {
            switch self {
            case .heartRate: return "Current heart rate"
            case .steps: return "Daily step count"
            case .activeCalories: return "Calories burned through activity"
            case .sleep: return "Sleep duration and quality"
            case .stress: return "Stress level assessment"
            case .bloodOxygen: return "Blood oxygen saturation"
            case .hrv: return "Heart rate variability"
            case .restingHeartRate: return "Resting heart rate"
            case .workout: return "Active workout time"
            case .hydration: return "Daily water intake"
            case .weight: return "Body weight tracking"
            case .bodyFat: return "Body fat percentage"
            }
        }
    }
    
    enum TrendDirection {
        case up, down, stable
        
        var icon: String {
            switch self {
            case .up: return "arrow.up.right"
            case .down: return "arrow.down.right"
            case .stable: return "minus"
            }
        }
        
        var color: Color {
            switch self {
            case .up: return .success
            case .down: return .error
            case .stable: return .textSecondary
            }
        }
    }
}

struct HealthDataPoint {
    let timestamp: Date
    let value: Double
    let quality: DataQuality?
    
    enum DataQuality {
        case high, medium, low
        
        var color: Color {
            switch self {
            case .high: return .success
            case .medium: return .warning
            case .low: return .error
            }
        }
    }
}

struct TargetRange {
    let min: Double
    let max: Double
    let optimal: Double?
    let unit: String
    
    func status(for value: Double) -> RangeStatus {
        if value < min {
            return .below
        } else if value > max {
            return .above
        } else if let optimal = optimal {
            let tolerance = (max - min) * 0.1
            if abs(value - optimal) <= tolerance {
                return .optimal
            }
        }
        return .normal
    }
    
    enum RangeStatus {
        case below, normal, optimal, above
        
        var color: Color {
            switch self {
            case .below, .above: return .error
            case .normal: return .warning
            case .optimal: return .success
            }
        }
        
        var description: String {
            switch self {
            case .below: return "Below target"
            case .normal: return "Within range"
            case .optimal: return "Optimal"
            case .above: return "Above target"
            }
        }
    }
}

enum TimeRange: String, CaseIterable {
    case today = "Today"
    case week = "7 Days"
    case month = "30 Days"
    case quarter = "3 Months"
    case year = "1 Year"
    
    var days: Int {
        switch self {
        case .today: return 1
        case .week: return 7
        case .month: return 30
        case .quarter: return 90
        case .year: return 365
        }
    }
    
    var icon: String {
        switch self {
        case .today: return "calendar"
        case .week: return "calendar.badge.clock"
        case .month: return "calendar"
        case .quarter: return "calendar.badge.minus"
        case .year: return "calendar.badge.plus"
        }
    }
}

// MARK: - Mock ViewModel
class MockHealthCardsViewModel: HealthCardsViewModeling {
    @Published var healthCards: [HealthCard] = []
    @Published var selectedCard: HealthCard? = nil
    @Published var selectedTimeRange: TimeRange = .week
    @Published var isLoading = false
    @Published var lastUpdateTime: Date? = Date()
    
    init() {
        loadMockHealthCards()
    }
    
    private func loadMockHealthCards() {
        // Generate mock chart data
        let chartData = generateMockChartData()
        
        healthCards = [
            HealthCard(
                type: .heartRate,
                currentValue: "72",
                unit: "bpm",
                trend: .stable,
                trendPercentage: 2.1,
                chartData: chartData,
                insights: [
                    "Your heart rate is within normal range",
                    "Consistent pattern over the past week",
                    "Best reading was 68 bpm during rest"
                ],
                recommendations: [
                    "Maintain regular cardio exercise",
                    "Consider meditation for lower resting HR",
                    "Monitor during high-stress periods"
                ],
                lastUpdated: Date().addingTimeInterval(-300),
                isAvailable: true,
                targetRange: TargetRange(min: 60, max: 100, optimal: 70, unit: "bpm")
            ),
            HealthCard(
                type: .steps,
                currentValue: "8,432",
                unit: "steps",
                trend: .up,
                trendPercentage: 12.5,
                chartData: chartData,
                insights: [
                    "Great job! You're 12% more active this week",
                    "Exceeded daily goal 5 out of 7 days",
                    "Most active day: 12,450 steps"
                ],
                recommendations: [
                    "You're on track! Keep it up",
                    "Try adding evening walks",
                    "Consider increasing daily goal to 10k"
                ],
                lastUpdated: Date().addingTimeInterval(-600),
                isAvailable: true,
                targetRange: TargetRange(min: 7000, max: 15000, optimal: 10000, unit: "steps")
            ),
            HealthCard(
                type: .sleep,
                currentValue: "7h 32m",
                unit: "",
                trend: .down,
                trendPercentage: 8.3,
                chartData: chartData,
                insights: [
                    "Sleep duration decreased by 8% this week",
                    "Average bedtime: 11:30 PM",
                    "Sleep efficiency: 89%"
                ],
                recommendations: [
                    "Try to maintain consistent bedtime",
                    "Limit screen time before bed",
                    "Consider a relaxing bedtime routine"
                ],
                lastUpdated: Date().addingTimeInterval(-28800),
                isAvailable: true,
                targetRange: TargetRange(min: 7, max: 9, optimal: 8, unit: "hours")
            ),
            HealthCard(
                type: .stress,
                currentValue: "Low",
                unit: "",
                trend: .down,
                trendPercentage: 15.2,
                chartData: chartData,
                insights: [
                    "Stress levels decreased by 15% this week",
                    "Best stress management on weekends",
                    "Peak stress periods: 2-4 PM weekdays"
                ],
                recommendations: [
                    "Great stress management this week!",
                    "Continue your current practices",
                    "Consider short breaks during peak hours"
                ],
                lastUpdated: Date().addingTimeInterval(-1200),
                isAvailable: true,
                targetRange: nil
            ),
            HealthCard(
                type: .activeCalories,
                currentValue: "324",
                unit: "cal",
                trend: .up,
                trendPercentage: 6.8,
                chartData: chartData,
                insights: [
                    "Active calories increased by 7% this week",
                    "Most active workout: 45 min cycling",
                    "Consistent daily activity"
                ],
                recommendations: [
                    "Great activity level!",
                    "Mix cardio with strength training",
                    "Stay hydrated during workouts"
                ],
                lastUpdated: Date().addingTimeInterval(-900),
                isAvailable: true,
                targetRange: TargetRange(min: 200, max: 600, optimal: 400, unit: "cal")
            ),
            HealthCard(
                type: .bloodOxygen,
                currentValue: "98%",
                unit: "",
                trend: .stable,
                trendPercentage: 0.5,
                chartData: chartData,
                insights: [
                    "Excellent oxygen saturation levels",
                    "Consistent readings throughout the day",
                    "No concerning variations detected"
                ],
                recommendations: [
                    "Maintain current activity level",
                    "Continue regular outdoor activities",
                    "Monitor during illness"
                ],
                lastUpdated: Date().addingTimeInterval(-1800),
                isAvailable: true,
                targetRange: TargetRange(min: 95, max: 100, optimal: 98, unit: "%")
            )
        ]
    }
    
    private func generateMockChartData() -> [HealthDataPoint] {
        let now = Date()
        var data: [HealthDataPoint] = []
        
        for i in 0..<30 {
            let date = Calendar.current.date(byAdding: .day, value: -i, to: now) ?? now
            let value = Double.random(in: 50...100)
            let quality = HealthDataPoint.DataQuality.allCases.randomElement() ?? .high
            
            data.append(HealthDataPoint(timestamp: date, value: value, quality: quality))
        }
        
        return data.reversed()
    }
    
    func refreshHealthData() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.loadMockHealthCards()
            self.lastUpdateTime = Date()
            self.isLoading = false
        }
    }
    
    func loadDetailedData(for card: HealthCard) {
        selectedCard = card
    }
    
    func exportHealthData() {
        // Export logic
    }
    
    func shareHealthInsights() {
        // Share logic
    }
}

// MARK: - Main Health Cards View
struct NutriHealthCardsView<ViewModel: HealthCardsViewModeling>: View {
    @StateObject private var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header with last update and time range
                HealthDataHeaderView(
                    lastUpdateTime: viewModel.lastUpdateTime,
                    selectedTimeRange: $viewModel.selectedTimeRange,
                    isLoading: viewModel.isLoading,
                    onRefresh: viewModel.refreshHealthData
                )
                .padding(.horizontal)
                .padding(.bottom)
                
                // Content
                if viewModel.isLoading && viewModel.healthCards.isEmpty {
                    Spacer()
                    ProgressView("Loading health data...")
                        .scaleEffect(1.2)
                    Spacer()
                } else if viewModel.healthCards.isEmpty {
                    EmptyHealthDataView(onRefresh: viewModel.refreshHealthData)
                } else {
                    ScrollView {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                            ForEach(viewModel.healthCards, id: \.id) { card in
                                HealthCardView(
                                    card: card,
                                    timeRange: viewModel.selectedTimeRange,
                                    onTap: { viewModel.loadDetailedData(for: card) }
                                )
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 100)
                    }
                }
            }
            .background(Color.backgroundPrimary)
            .navigationTitle("Health Data")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Export Data") {
                            viewModel.exportHealthData()
                        }
                        
                        Button("Share Insights") {
                            viewModel.shareHealthInsights()
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                    .accessibility(label: Text("Health data options"))
                }
            }
            .refreshable {
                viewModel.refreshHealthData()
            }
        }
        .sheet(item: $viewModel.selectedCard) { card in
            HealthCardDetailView(
                card: card,
                timeRange: viewModel.selectedTimeRange
            )
        }
    }
}

// MARK: - Health Data Header
struct HealthDataHeaderView: View {
    let lastUpdateTime: Date?
    @Binding var selectedTimeRange: TimeRange
    let isLoading: Bool
    let onRefresh: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            // Last update info
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Health Overview")
                        .headline()
                        .foregroundColor(.textPrimary)
                    
                    if let lastUpdate = lastUpdateTime {
                        Text("Updated \(lastUpdate, formatter: updateTimeFormatter)")
                            .caption()
                            .foregroundColor(.textSecondary)
                    } else {
                        Text("No recent updates")
                            .caption()
                            .foregroundColor(.textSecondary)
                    }
                }
                
                Spacer()
                
                Button(action: onRefresh) {
                    if isLoading {
                        ProgressView()
                            .scaleEffect(0.8)
                    } else {
                        Image(systemName: SystemIcon.refresh)
                            .font(.title3)
                            .foregroundColor(.accentPrimary)
                    }
                }
                .disabled(isLoading)
                .accessibility(label: Text("Refresh health data"))
            }
            
            // Time range selector
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(TimeRange.allCases, id: \.self) { range in
                        TimeRangeChip(
                            range: range,
                            isSelected: selectedTimeRange == range,
                            onTap: { selectedTimeRange = range }
                        )
                    }
                }
                .padding(.horizontal, 1)
            }
        }
    }
}

struct TimeRangeChip: View {
    let range: TimeRange
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 6) {
                Image(systemName: range.icon)
                    .font(.caption)
                
                Text(range.rawValue)
                    .caption()
                    .fontWeight(.medium)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(isSelected ? Color.accentPrimary.opacity(0.2) : Color.backgroundSecondary)
            .foregroundColor(isSelected ? .accentPrimary : .textPrimary)
            .cornerRadius(8)
        }
        .accessibility(label: Text("\(range.rawValue) time range"))
        .accessibility(hint: Text(isSelected ? "Currently selected" : "Tap to select this time range"))
    }
}

// MARK: - Health Card
struct HealthCardView: View {
    let card: HealthCard
    let timeRange: TimeRange
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            NutriCard {
                VStack(alignment: .leading, spacing: 12) {
                    // Header with icon and trend
                    HStack {
                        Image(systemName: card.type.icon)
                            .font(.title3)
                            .foregroundColor(card.type.color)
                            .frame(width: 24, height: 24)
                        
                        Spacer()
                        
                        if card.isAvailable {
                            HStack(spacing: 4) {
                                Image(systemName: card.trend.icon)
                                    .font(.caption2)
                                Text(String(format: "%.1f%%", card.trendPercentage))
                                    .caption2()
                                    .fontWeight(.medium)
                            }
                            .foregroundColor(card.trend.color)
                        }
                    }
                    
                    // Type name
                    Text(card.type.rawValue)
                        .caption()
                        .foregroundColor(.textSecondary)
                        .lineLimit(1)
                    
                    // Current value
                    if card.isAvailable {
                        HStack(alignment: .firstTextBaseline, spacing: 4) {
                            Text(card.currentValue)
                                .title2()
                                .fontWeight(.semibold)
                                .foregroundColor(.textPrimary)
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                            
                            if !card.unit.isEmpty {
                                Text(card.unit)
                                    .caption()
                                    .foregroundColor(.textSecondary)
                            }
                        }
                        
                        // Target range indicator
                        if let targetRange = card.targetRange,
                           let currentValueDouble = Double(card.currentValue.replacingOccurrences(of: ",", with: "")) {
                            let status = targetRange.status(for: currentValueDouble)
                            
                            HStack(spacing: 4) {
                                Circle()
                                    .fill(status.color)
                                    .frame(width: 6, height: 6)
                                
                                Text(status.description)
                                    .caption2()
                                    .foregroundColor(status.color)
                            }
                        }
                        
                        // Mini chart
                        MiniChartView(data: card.chartData, color: card.type.color)
                            .frame(height: 30)
                    } else {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Not Available")
                                .headline()
                                .foregroundColor(.textTertiary)
                            
                            Text("Connect your Apple Watch or Health app")
                                .caption2()
                                .foregroundColor(.textTertiary)
                                .multilineTextAlignment(.leading)
                        }
                    }
                }
                .padding(16)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .accessibility(label: Text("\(card.type.rawValue): \(card.currentValue) \(card.unit)"))
        .accessibility(hint: Text("Tap for detailed view"))
    }
}

// MARK: - Mini Chart
struct MiniChartView: View {
    let data: [HealthDataPoint]
    let color: Color
    
    var body: some View {
        GeometryReader { geometry in
            let maxValue = data.map(\.value).max() ?? 1
            let minValue = data.map(\.value).min() ?? 0
            let range = maxValue - minValue
            
            Path { path in
                guard data.count > 1 else { return }
                
                let stepX = geometry.size.width / CGFloat(data.count - 1)
                
                for (index, point) in data.enumerated() {
                    let x = CGFloat(index) * stepX
                    let normalizedValue = range > 0 ? (point.value - minValue) / range : 0.5
                    let y = geometry.size.height * (1 - normalizedValue)
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: x, y: y))
                    } else {
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
            }
            .stroke(color, lineWidth: 2)
        }
    }
}

// MARK: - Empty State
struct EmptyHealthDataView: View {
    let onRefresh: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "heart.text.square")
                .font(.system(size: 64))
                .foregroundColor(.textTertiary)
            
            VStack(spacing: 8) {
                Text("No Health Data")
                    .title2()
                    .foregroundColor(.textPrimary)
                
                Text("Connect your Apple Watch or Health app to see your health metrics.")
                    .body()
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            VStack(spacing: 12) {
                Button("Open Health App") {
                    // Open Health app
                }
                .buttonStyle(PrimaryButtonStyle())
                .padding(.horizontal, 60)
                
                Button("Refresh") {
                    onRefresh()
                }
                .buttonStyle(SecondaryButtonStyle())
                .padding(.horizontal, 80)
            }
            
            Spacer()
        }
    }
}

// MARK: - Detail View
struct HealthCardDetailView: View {
    let card: HealthCard
    let timeRange: TimeRange
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Hero section
                    HealthCardHeroView(card: card)
                    
                    // Detailed chart
                    DetailedChartSection(card: card, timeRange: timeRange)
                    
                    // Target range
                    if let targetRange = card.targetRange {
                        TargetRangeSection(targetRange: targetRange, currentValue: card.currentValue)
                    }
                    
                    // Insights
                    InsightsSection(insights: card.insights)
                    
                    // Recommendations
                    RecommendationsSection(recommendations: card.recommendations)
                    
                    Spacer(minLength: 40)
                }
                .padding()
            }
            .background(Color.backgroundPrimary)
            .navigationTitle(card.type.rawValue)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Export Data") {
                            // Export this metric's data
                        }
                        
                        Button("Share Chart") {
                            // Share chart
                        }
                        
                        Button("Set Goal") {
                            // Set personal goal
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
        }
    }
}

// MARK: - Detail View Components
struct HealthCardHeroView: View {
    let card: HealthCard
    
    var body: some View {
        NutriCard {
            VStack(spacing: 16) {
                Image(systemName: card.type.icon)
                    .font(.system(size: 48))
                    .foregroundColor(card.type.color)
                    .frame(width: 80, height: 80)
                    .background(card.type.color.opacity(0.1))
                    .cornerRadius(40)
                
                VStack(spacing: 8) {
                    Text(card.type.rawValue)
                        .title()
                        .foregroundColor(.textPrimary)
                    
                    Text(card.type.description)
                        .body()
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.center)
                }
                
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Text(card.currentValue)
                        .largeTitle()
                        .fontWeight(.bold)
                        .foregroundColor(.textPrimary)
                    
                    if !card.unit.isEmpty {
                        Text(card.unit)
                            .title3()
                            .foregroundColor(.textSecondary)
                    }
                }
                
                HStack(spacing: 8) {
                    Image(systemName: card.trend.icon)
                        .font(.caption)
                    
                    Text("\(String(format: "%.1f", card.trendPercentage))% from last period")
                        .caption()
                }
                .foregroundColor(card.trend.color)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(card.trend.color.opacity(0.1))
                .cornerRadius(8)
            }
            .padding(20)
        }
    }
}

struct DetailedChartSection: View {
    let card: HealthCard
    let timeRange: TimeRange
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Trends")
                .headline()
                .foregroundColor(.textPrimary)
            
            NutriCard {
                VStack(spacing: 16) {
                    DetailedChartView(data: card.chartData, color: card.type.color)
                        .frame(height: 200)
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Average")
                                .caption()
                                .foregroundColor(.textSecondary)
                            
                            let average = card.chartData.map(\.value).reduce(0, +) / Double(card.chartData.count)
                            Text(String(format: "%.1f", average))
                                .headline()
                                .foregroundColor(.textPrimary)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("Range")
                                .caption()
                                .foregroundColor(.textSecondary)
                            
                            let minVal = card.chartData.map(\.value).min() ?? 0
                            let maxVal = card.chartData.map(\.value).max() ?? 0
                            Text("\(String(format: "%.0f", minVal)) - \(String(format: "%.0f", maxVal))")
                                .headline()
                                .foregroundColor(.textPrimary)
                        }
                    }
                }
                .padding(16)
            }
        }
    }
}

struct DetailedChartView: View {
    let data: [HealthDataPoint]
    let color: Color
    
    var body: some View {
        GeometryReader { geometry in
            let maxValue = data.map(\.value).max() ?? 1
            let minValue = data.map(\.value).min() ?? 0
            let range = maxValue - minValue
            
            ZStack {
                // Background grid lines
                Path { path in
                    for i in 0...4 {
                        let y = geometry.size.height * CGFloat(i) / 4
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: geometry.size.width, y: y))
                    }
                }
                .stroke(Color.backgroundTertiary, lineWidth: 1)
                
                // Data line
                Path { path in
                    guard data.count > 1 else { return }
                    
                    let stepX = geometry.size.width / CGFloat(data.count - 1)
                    
                    for (index, point) in data.enumerated() {
                        let x = CGFloat(index) * stepX
                        let normalizedValue = range > 0 ? (point.value - minValue) / range : 0.5
                        let y = geometry.size.height * (1 - normalizedValue)
                        
                        if index == 0 {
                            path.move(to: CGPoint(x: x, y: y))
                        } else {
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                    }
                }
                .stroke(color, lineWidth: 3)
                
                // Data points
                ForEach(Array(data.enumerated()), id: \.offset) { index, point in
                    let x = geometry.size.width * CGFloat(index) / CGFloat(max(data.count - 1, 1))
                    let normalizedValue = range > 0 ? (point.value - minValue) / range : 0.5
                    let y = geometry.size.height * (1 - normalizedValue)
                    
                    Circle()
                        .fill(point.quality?.color ?? color)
                        .frame(width: 6, height: 6)
                        .position(x: x, y: y)
                }
            }
        }
    }
}

struct TargetRangeSection: View {
    let targetRange: TargetRange
    let currentValue: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Target Range")
                .headline()
                .foregroundColor(.textPrimary)
            
            if let currentValueDouble = Double(currentValue.replacingOccurrences(of: ",", with: "")) {
                let status = targetRange.status(for: currentValueDouble)
                
                NutriCard(backgroundColor: status.color.opacity(0.1)) {
                    VStack(spacing: 16) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Current Status")
                                    .caption()
                                    .foregroundColor(.textSecondary)
                                
                                HStack(spacing: 8) {
                                    Circle()
                                        .fill(status.color)
                                        .frame(width: 8, height: 8)
                                    
                                    Text(status.description)
                                        .headline()
                                        .foregroundColor(status.color)
                                }
                            }
                            
                            Spacer()
                        }
                        
                        VStack(spacing: 8) {
                            HStack {
                                Text("Min")
                                    .caption()
                                    .foregroundColor(.textSecondary)
                                Spacer()
                                Text("\(String(format: "%.0f", targetRange.min)) \(targetRange.unit)")
                                    .caption()
                                    .foregroundColor(.textPrimary)
                            }
                            
                            if let optimal = targetRange.optimal {
                                HStack {
                                    Text("Optimal")
                                        .caption()
                                        .foregroundColor(.textSecondary)
                                    Spacer()
                                    Text("\(String(format: "%.0f", optimal)) \(targetRange.unit)")
                                        .caption()
                                        .fontWeight(.medium)
                                        .foregroundColor(.success)
                                }
                            }
                            
                            HStack {
                                Text("Max")
                                    .caption()
                                    .foregroundColor(.textSecondary)
                                Spacer()
                                Text("\(String(format: "%.0f", targetRange.max)) \(targetRange.unit)")
                                    .caption()
                                    .foregroundColor(.textPrimary)
                            }
                        }
                    }
                    .padding(16)
                }
            }
        }
    }
}

struct InsightsSection: View {
    let insights: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Insights")
                .headline()
                .foregroundColor(.textPrimary)
            
            VStack(spacing: 12) {
                ForEach(Array(insights.enumerated()), id: \.offset) { index, insight in
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: SystemIcon.info)
                            .font(.title3)
                            .foregroundColor(.accentPrimary)
                            .frame(width: 24, height: 24)
                        
                        Text(insight)
                            .body()
                            .foregroundColor(.textPrimary)
                        
                        Spacer()
                    }
                }
            }
        }
    }
}

struct RecommendationsSection: View {
    let recommendations: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recommendations")
                .headline()
                .foregroundColor(.textPrimary)
            
            VStack(spacing: 12) {
                ForEach(Array(recommendations.enumerated()), id: \.offset) { index, recommendation in
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: SystemIcon.checkmark)
                            .font(.title3)
                            .foregroundColor(.success)
                            .frame(width: 24, height: 24)
                        
                        Text(recommendation)
                            .body()
                            .foregroundColor(.textPrimary)
                        
                        Spacer()
                    }
                }
            }
        }
    }
}

// MARK: - Helper Formatters
private let updateTimeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .none
    formatter.timeStyle = .short
    return formatter
}()

// MARK: - Preview
struct NutriHealthCardsView_Previews: PreviewProvider {
    static var previews: some View {
        DevicePreview {
            NutriHealthCardsView(viewModel: MockHealthCardsViewModel())
        }
        .previewDevice("iPhone 15 Pro")
    }
}
