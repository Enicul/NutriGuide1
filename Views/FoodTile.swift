import SwiftUI

struct FoodTile: View {
    let food: Food
    let onEatThis: () -> Void
    let onShowAlternatives: () -> Void
    
    var body: some View {
        ERNCard {
            VStack(spacing: 12) {
                // Main info row
                HStack(alignment: .top, spacing: 12) {
                    // Food emoji
                    Text(food.emoji)
                        .font(.system(size: 32))
                        .accessibilityHidden(true)
                    
                    // Food info
                    VStack(alignment: .leading, spacing: 4) {
                        Text(food.name)
                            .ernHeadline()
                        
                        Text(food.rationale)
                            .ernCaption()
                            .foregroundColor(.ernTextSecondary)
                    }
                    
                    Spacer()
                    
                    // Alternative options button
                    Button(action: onShowAlternatives) {
                        ERNIconView(ERNIcon.alternatives, color: .ernTextSecondary, size: 16)
                    }
                    .accessibilityLabel("View alternative options")
                }
                
                // Nutrition info
                Text(food.nutrition.quickFacts)
                    .ernCaption()
                    .foregroundColor(.ernTextSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // Portion info
                Text(food.portionText)
                    .ernCaption2()
                    .foregroundColor(.ernTextTertiary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // Diet and allergy flags
                if food.hasDietFlags || food.hasAllergyFlags {
                    HStack(spacing: 8) {
                        if food.hasDietFlags {
                            HStack(spacing: 4) {
                                ERNIconView(ERNIcon.vegan, color: .ernSuccess, size: 12)
                                Text(food.displayDietFlags)
                                    .ernCaption2()
                                    .foregroundColor(.ernSuccess)
                            }
                        }
                        
                        if food.hasAllergyFlags {
                            HStack(spacing: 4) {
                                ERNIconView(ERNIcon.nutFree, color: .ernWarning, size: 12)
                                Text(food.displayAllergyFlags)
                                    .ernCaption2()
                                    .foregroundColor(.ernWarning)
                            }
                        }
                        
                        Spacer()
                    }
                }
                
                // Action button
                Button("Eat this") {
                    onEatThis()
                }
                .ernPrimary()
                .frame(maxWidth: .infinity)
                .accessibilityLabel("Select \(food.name)")
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("\(food.name), \(food.rationale), \(food.portionText)")
    }
}

// MARK: - Preview
#Preview {
    ScrollView {
        VStack(spacing: 16) {
            FoodTile(
                food: Food(
                    name: "Banana",
                    emoji: "🍌",
                    nutrition: Nutrition(kcal: 105, carbs: 27, protein: 1.3, fat: 0.4, micros: ["Mg": 32, "B6": 0.4]),
                    tags: ["common"],
                    portionText: "1 medium (120 g)",
                    dietFlags: ["Vegetarian", "Halal"],
                    allergyFlags: [],
                    rationale: "Rich in magnesium and B6, helps relieve stress and anxiety"
                ),
                onEatThis: { print("Eat banana") },
                onShowAlternatives: { print("Show alternatives") }
            )
            
            FoodTile(
                food: Food(
                    name: "Dark Chocolate (70%+)",
                    emoji: "🍫",
                    nutrition: Nutrition(kcal: 170, carbs: 13, protein: 2.7, fat: 12, micros: ["Mg": 64]),
                    tags: ["treat"],
                    portionText: "30 g (3-4 pieces)",
                    dietFlags: ["Vegetarian"],
                    allergyFlags: ["Dairy (check label)"],
                    rationale: "High magnesium content, theobromine helps improve mood"
                ),
                onEatThis: { print("Eat chocolate") },
                onShowAlternatives: { print("Show alternatives") }
            )
        }
        .padding()
    }
    .background(Color.ernBackground)
}
