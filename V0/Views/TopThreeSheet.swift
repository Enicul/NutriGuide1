import SwiftUI

struct TopThreeSheet: View {
    @ObservedObject var viewModel: HomeViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if let recommendation = viewModel.currentRecommendation {
                    // Title
                    VStack(spacing: 8) {
                        Text(recommendation.title)
                            .ernTitle2()
                            .multilineTextAlignment(.center)
                        
                        Text(recommendation.shortReason)
                            .ernBody()
                            .foregroundColor(.ernTextSecondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    // Food list
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            if recommendation.foods.isEmpty {
                                // No matching foods message
                                VStack(spacing: 16) {
                                    Image(systemName: "exclamationmark.triangle")
                                        .font(.system(size: 48))
                                        .foregroundColor(.ernTextSecondary)
                                    
                                    Text("No items match your settings")
                                        .ernTitle3()
                                        .multilineTextAlignment(.center)
                                    
                                    Text("Try relaxing your dietary filters or adding more items to your pantry in Settings.")
                                        .ernBody()
                                        .foregroundColor(.ernTextSecondary)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal)
                                }
                                .padding(.vertical, 40)
                            } else {
                                ForEach(recommendation.foods) { food in
                                    FoodTile(
                                        food: food,
                                        onEatThis: {
                                            // TODO: Implement "eat this" functionality
                                            print("Selected: \(food.name)")
                                        },
                                        onShowAlternatives: {
                                            // TODO: Implement alternative options functionality
                                            print("Show alternatives for: \(food.name)")
                                        }
                                    )
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 20)
                    }
                    
                    // Bottom info
                    VStack(spacing: 8) {
                        Divider()
                        
                        HStack {
                            Text("Dietary flags and allergy information are for reference only")
                                .ernCaption2()
                                .foregroundColor(.ernTextTertiary)
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 8)
                    }
                } else {
                    // Loading state
                    VStack(spacing: 16) {
                        ProgressView()
                        Text("Loading recommendations...")
                            .ernBody()
                            .foregroundColor(.ernTextSecondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .background(Color.ernBackground)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        viewModel.dismissTopThree()
                    }
                    .ernTertiary()
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}

// MARK: - Preview
#Preview {
    TopThreeSheet(viewModel: {
        let vm = HomeViewModel()
        vm.fetchTopThree()
        return vm
    }())
}
