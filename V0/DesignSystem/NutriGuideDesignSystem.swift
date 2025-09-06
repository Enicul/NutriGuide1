// This file is self-contained. Rename or integrate according to your project's conventions.

import SwiftUI

// MARK: - Semantic Color System
extension Color {
    // MARK: - Background Colors
    static let backgroundPrimary = Color(.systemBackground)
    static let backgroundSecondary = Color(.secondarySystemBackground)
    static let backgroundTertiary = Color(.tertiarySystemBackground)
    static let backgroundCard = Color(.secondarySystemBackground)
    
    // MARK: - Text Colors
    static let textPrimary = Color(.label)
    static let textSecondary = Color(.secondaryLabel)
    static let textTertiary = Color(.tertiaryLabel)
    static let textOnAccent = Color.white
    
    // MARK: - Brand Colors
    static let accentPrimary = Color.blue
    static let accentSecondary = Color.blue.opacity(0.8)
    static let accentTertiary = Color.blue.opacity(0.6)
    
    // MARK: - Semantic Colors
    static let success = Color.green
    static let warning = Color.orange
    static let error = Color.red
    static let info = Color.blue
    
    // MARK: - Health State Colors
    static let stateCalm = Color.mint
    static let stateStressed = Color.orange
    static let stateLowEnergy = Color.yellow
    static let statePostWorkout = Color.red
    static let stateSleepPrep = Color.purple
    static let stateFocusNeeded = Color.blue
    
    // MARK: - Nutrition Colors
    static let nutritionProtein = Color.red.opacity(0.8)
    static let nutritionCarbs = Color.orange.opacity(0.8)
    static let nutritionFat = Color.yellow.opacity(0.8)
    static let nutritionFiber = Color.green.opacity(0.8)
    
    // MARK: - Shadow Colors
    static let shadowLight = Color.black.opacity(0.05)
    static let shadowMedium = Color.black.opacity(0.1)
    static let shadowDark = Color.black.opacity(0.2)
}

// MARK: - Typography System
extension Text {
    func largeTitle() -> some View {
        self.font(.largeTitle)
            .fontWeight(.bold)
            .fontDesign(.rounded)
    }
    
    func title() -> some View {
        self.font(.title)
            .fontWeight(.semibold)
            .fontDesign(.rounded)
    }
    
    func title2() -> some View {
        self.font(.title2)
            .fontWeight(.semibold)
            .fontDesign(.rounded)
    }
    
    func title3() -> some View {
        self.font(.title3)
            .fontWeight(.medium)
            .fontDesign(.rounded)
    }
    
    func headline() -> some View {
        self.font(.headline)
            .fontWeight(.semibold)
    }
    
    func subheadline() -> some View {
        self.font(.subheadline)
            .fontWeight(.medium)
    }
    
    func body() -> some View {
        self.font(.body)
    }
    
    func callout() -> some View {
        self.font(.callout)
    }
    
    func footnote() -> some View {
        self.font(.footnote)
    }
    
    func caption() -> some View {
        self.font(.caption)
    }
    
    func caption2() -> some View {
        self.font(.caption2)
    }
}

// MARK: - Button Styles
struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .fontWeight(.semibold)
            .foregroundColor(.textOnAccent)
            .frame(minHeight: 44)
            .frame(maxWidth: .infinity)
            .background(Color.accentPrimary)
            .cornerRadius(12)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .fontWeight(.semibold)
            .foregroundColor(.accentPrimary)
            .frame(minHeight: 44)
            .frame(maxWidth: .infinity)
            .background(Color.backgroundSecondary)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.accentPrimary, lineWidth: 1)
            )
            .cornerRadius(12)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct TertiaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .fontWeight(.medium)
            .foregroundColor(.accentPrimary)
            .frame(minHeight: 44)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Card Component
struct NutriCard<Content: View>: View {
    let content: Content
    let backgroundColor: Color
    let shadowLevel: Int
    
    init(
        backgroundColor: Color = .backgroundCard,
        shadowLevel: Int = 1,
        @ViewBuilder content: () -> Content
    ) {
        self.backgroundColor = backgroundColor
        self.shadowLevel = shadowLevel
        self.content = content()
    }
    
    var body: some View {
        content
            .background(backgroundColor)
            .cornerRadius(16)
            .shadow(
                color: shadowColor,
                radius: CGFloat(shadowLevel * 2),
                x: 0,
                y: CGFloat(shadowLevel)
            )
    }
    
    private var shadowColor: Color {
        switch shadowLevel {
        case 0: return .clear
        case 1: return .shadowLight
        case 2: return .shadowMedium
        default: return .shadowDark
        }
    }
}

// MARK: - Icon System
struct SystemIcon {
    static let home = "house.fill"
    static let sync = "applewatch"
    static let settings = "gearshape.fill"
    static let heart = "heart.fill"
    static let activity = "figure.run"
    static let nutrition = "leaf.fill"
    static let sleep = "moon.fill"
    static let stress = "brain.head.profile"
    static let energy = "bolt.fill"
    static let focus = "eye.fill"
    static let location = "location.fill"
    static let clock = "clock.fill"
    static let checkmark = "checkmark.circle.fill"
    static let plus = "plus.circle.fill"
    static let minus = "minus.circle.fill"
    static let info = "info.circle.fill"
    static let warning = "exclamationmark.triangle.fill"
    static let error = "xmark.circle.fill"
    static let refresh = "arrow.clockwise"
    static let share = "square.and.arrow.up"
    static let bookmark = "bookmark.fill"
    static let star = "star.fill"
    static let filter = "line.3.horizontal.decrease.circle"
    static let search = "magnifyingglass"
    static let camera = "camera.fill"
    static let photo = "photo.fill"
    static let edit = "pencil"
    static let delete = "trash.fill"
    static let close = "xmark"
}

// MARK: - Health State Tag
struct HealthStateTag: View {
    let state: HealthState
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: state.icon)
                .font(.caption)
                .fontWeight(.medium)
            
            Text(state.title)
                .caption()
                .fontWeight(.medium)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(state.color.opacity(0.2))
        .foregroundColor(state.color)
        .cornerRadius(12)
    }
}

// MARK: - Nutrition Badge
struct NutritionBadge: View {
    let nutrient: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .footnote()
                .fontWeight(.semibold)
                .foregroundColor(color)
            
            Text(nutrient)
                .caption2()
                .foregroundColor(.textSecondary)
        }
        .frame(minWidth: 60)
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(color.opacity(0.1))
        .cornerRadius(8)
    }
}

// MARK: - Sample Data Models
enum HealthState: String, CaseIterable {
    case calm = "calm"
    case stressed = "stressed"
    case lowEnergy = "low_energy"
    case postWorkout = "post_workout"
    case sleepPrep = "sleep_prep"
    case focusNeeded = "focus_needed"
    
    var title: String {
        switch self {
        case .calm: return "Calm"
        case .stressed: return "Stressed"
        case .lowEnergy: return "Low Energy"
        case .postWorkout: return "Post-Workout"
        case .sleepPrep: return "Sleep Prep"
        case .focusNeeded: return "Focus Needed"
        }
    }
    
    var icon: String {
        switch self {
        case .calm: return SystemIcon.heart
        case .stressed: return SystemIcon.stress
        case .lowEnergy: return SystemIcon.energy
        case .postWorkout: return SystemIcon.activity
        case .sleepPrep: return SystemIcon.sleep
        case .focusNeeded: return SystemIcon.focus
        }
    }
    
    var color: Color {
        switch self {
        case .calm: return .stateCalm
        case .stressed: return .stateStressed
        case .lowEnergy: return .stateLowEnergy
        case .postWorkout: return .statePostWorkout
        case .sleepPrep: return .stateSleepPrep
        case .focusNeeded: return .stateFocusNeeded
        }
    }
    
    var description: String {
        switch self {
        case .calm: return "Feeling relaxed and peaceful"
        case .stressed: return "High stress levels detected"
        case .lowEnergy: return "Energy levels are low"
        case .postWorkout: return "Recovery mode after exercise"
        case .sleepPrep: return "Preparing for sleep"
        case .focusNeeded: return "Need to improve concentration"
        }
    }
}

struct MockFood {
    let id = UUID()
    let name: String
    let category: String
    let nutrition: MockNutrition
    let benefits: [String]
    let imageSystemName: String
    let isAvailableNearby: Bool
    let estimatedTime: String
    
    static let samples = [
        MockFood(
            name: "Blueberry Smoothie",
            category: "Beverage",
            nutrition: MockNutrition(calories: 180, protein: 8, carbs: 35, fat: 3, fiber: 6),
            benefits: ["Antioxidants", "Brain Health", "Energy Boost"],
            imageSystemName: "cup.and.saucer.fill",
            isAvailableNearby: true,
            estimatedTime: "5 min"
        ),
        MockFood(
            name: "Greek Yogurt with Berries",
            category: "Snack",
            nutrition: MockNutrition(calories: 150, protein: 15, carbs: 20, fat: 5, fiber: 4),
            benefits: ["Probiotics", "Protein", "Antioxidants"],
            imageSystemName: "birthday.cake.fill",
            isAvailableNearby: true,
            estimatedTime: "2 min"
        ),
        MockFood(
            name: "Avocado Toast",
            category: "Meal",
            nutrition: MockNutrition(calories: 320, protein: 12, carbs: 35, fat: 18, fiber: 12),
            benefits: ["Healthy Fats", "Fiber", "Sustained Energy"],
            imageSystemName: "takeoutbag.and.cup.and.straw.fill",
            isAvailableNearby: false,
            estimatedTime: "10 min"
        )
    ]
}

struct MockNutrition {
    let calories: Int
    let protein: Int
    let carbs: Int
    let fat: Int
    let fiber: Int
}

struct MockHealthMetric {
    let name: String
    let value: String
    let unit: String
    let icon: String
    let color: Color
    let trend: Trend
    
    enum Trend {
        case up, down, stable
        
        var icon: String {
            switch self {
            case .up: return "arrow.up"
            case .down: return "arrow.down"
            case .stable: return "minus"
            }
        }
    }
    
    static let samples = [
        MockHealthMetric(
            name: "Heart Rate",
            value: "72",
            unit: "bpm",
            icon: SystemIcon.heart,
            color: .error,
            trend: .stable
        ),
        MockHealthMetric(
            name: "Steps",
            value: "8,432",
            unit: "steps",
            icon: SystemIcon.activity,
            color: .success,
            trend: .up
        ),
        MockHealthMetric(
            name: "Sleep",
            value: "7h 32m",
            unit: "",
            icon: SystemIcon.sleep,
            color: .stateSleepPrep,
            trend: .down
        ),
        MockHealthMetric(
            name: "Stress",
            value: "Low",
            unit: "",
            icon: SystemIcon.stress,
            color: .stateCalm,
            trend: .down
        )
    ]
}

// MARK: - Preview Helper
struct DevicePreview<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .clipShape(RoundedRectangle(cornerRadius: 39))
            .overlay(
                RoundedRectangle(cornerRadius: 39)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
            .shadow(radius: 10)
    }
}

// MARK: - Design System Preview
struct NutriGuideDesignSystem_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Typography samples
                VStack(alignment: .leading, spacing: 12) {
                    Text("Typography System")
                        .title2()
                        .foregroundColor(.textPrimary)
                    
                    Text("Large Title").largeTitle()
                    Text("Title").title()
                    Text("Title 2").title2()
                    Text("Title 3").title3()
                    Text("Headline").headline()
                    Text("Subheadline").subheadline()
                    Text("Body").body()
                    Text("Callout").callout()
                    Text("Footnote").footnote()
                    Text("Caption").caption()
                }
                .padding()
                
                // Button styles
                VStack(spacing: 16) {
                    Text("Button Styles")
                        .title2()
                        .foregroundColor(.textPrimary)
                    
                    Button("Primary Button") {}
                        .buttonStyle(PrimaryButtonStyle())
                    
                    Button("Secondary Button") {}
                        .buttonStyle(SecondaryButtonStyle())
                    
                    Button("Tertiary Button") {}
                        .buttonStyle(TertiaryButtonStyle())
                }
                .padding()
                
                // Health state tags
                VStack(spacing: 12) {
                    Text("Health State Tags")
                        .title2()
                        .foregroundColor(.textPrimary)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                        ForEach(HealthState.allCases, id: \.self) { state in
                            HealthStateTag(state: state)
                        }
                    }
                }
                .padding()
                
                // Nutrition badges
                VStack(spacing: 12) {
                    Text("Nutrition Badges")
                        .title2()
                        .foregroundColor(.textPrimary)
                    
                    HStack(spacing: 12) {
                        NutritionBadge(nutrient: "Protein", value: "15g", color: .nutritionProtein)
                        NutritionBadge(nutrient: "Carbs", value: "35g", color: .nutritionCarbs)
                        NutritionBadge(nutrient: "Fat", value: "8g", color: .nutritionFat)
                        NutritionBadge(nutrient: "Fiber", value: "6g", color: .nutritionFiber)
                    }
                }
                .padding()
            }
        }
        .background(Color.backgroundPrimary)
        .previewDevice("iPhone 15 Pro")
    }
}
