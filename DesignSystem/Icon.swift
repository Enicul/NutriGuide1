import SwiftUI

struct ERNIcon {
    // MARK: - State Icons
    static let calm = "leaf.fill"
    static let stressed = "exclamationmark.triangle.fill"
    static let lowEnergy = "battery.25"
    static let postWorkout = "figure.strengthtraining.traditional"
    static let sleepPrep = "moon.fill"
    static let focusNeeded = "brain.head.profile"
    
    // MARK: - Action Icons
    static let showFoods = "fork.knife"
    static let whyThis = "questionmark.circle"
    static let snooze = "zzz"
    static let eatThis = "checkmark.circle.fill"
    static let alternatives = "chevron.right"
    static let close = "xmark"
    
    // MARK: - Nutrition Icons
    static let calories = "flame.fill"
    static let carbs = "leaf"
    static let protein = "dumbbell.fill"
    static let fat = "drop.fill"
    static let vitamins = "pills.fill"
    
    // MARK: - Diet & Allergy Icons
    static let vegan = "leaf.fill"
    static let vegetarian = "carrot.fill"
    static let halal = "moon.stars.fill"
    static let glutenFree = "wheat.slash"
    static let dairyFree = "drop.slash"
    static let nutFree = "tree.slash"
}

// MARK: - Icon View Helper
struct ERNIconView: View {
    let iconName: String
    let color: Color
    let size: CGFloat
    
    init(_ iconName: String, color: Color = .ernAccent, size: CGFloat = 20) {
        self.iconName = iconName
        self.color = color
        self.size = size
    }
    
    var body: some View {
        Image(systemName: iconName)
            .font(.system(size: size, weight: .medium))
            .foregroundColor(color)
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        HStack(spacing: 15) {
            ERNIconView(ERNIcon.calm, color: .ernCalm)
            ERNIconView(ERNIcon.stressed, color: .ernStressed)
            ERNIconView(ERNIcon.lowEnergy, color: .ernLowEnergy)
        }
        
        HStack(spacing: 15) {
            ERNIconView(ERNIcon.postWorkout, color: .ernPostWorkout)
            ERNIconView(ERNIcon.sleepPrep, color: .ernSleepPrep)
            ERNIconView(ERNIcon.focusNeeded, color: .ernFocusNeeded)
        }
        
        HStack(spacing: 15) {
            ERNIconView(ERNIcon.calories, color: .red)
            ERNIconView(ERNIcon.protein, color: .blue)
            ERNIconView(ERNIcon.vitamins, color: .green)
        }
    }
    .padding()
    .background(Color.ernBackground)
}
