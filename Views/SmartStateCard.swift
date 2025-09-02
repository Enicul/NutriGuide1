import SwiftUI

struct SmartStateCard: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        ERNCard {
            VStack(spacing: 16) {
                // State badge
                HStack {
                    ERNIconView(viewModel.currentState.iconName, color: viewModel.currentState.color, size: 24)
                    Text(viewModel.currentState.displayName)
                        .ernHeadline()
                        .foregroundColor(viewModel.currentState.color)
                    Spacer()
                }
                
                // Reason explanation
                Text(viewModel.rationale)
                    .ernBody()
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // Button group
                VStack(spacing: 12) {
                    // Main action button
                    Button("Show foods for now") {
                        viewModel.fetchTopThree()
                    }
                    .ernPrimary()
                    .frame(maxWidth: .infinity)
                    .accessibilityLabel("Show current food recommendations")
                    
                    // Secondary buttons
                    HStack(spacing: 12) {
                        Button("Why this?") {
                            viewModel.showWhyThis()
                        }
                        .ernSecondary()
                        .accessibilityLabel("Why are these foods recommended")
                        
                        Button("Snooze") {
                            viewModel.showSnoozeSheet = true
                        }
                        .ernTertiary()
                        .accessibilityLabel("Snooze recommendations")
                    }
                }
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Smart state card, current state: \(viewModel.currentState.displayName)")
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        SmartStateCard(viewModel: HomeViewModel())
        
        // Test different states
        SmartStateCard(viewModel: {
            let vm = HomeViewModel()
            vm.updateCurrentState(.lowEnergy)
            return vm
        }())
    }
    .padding()
    .background(Color.ernBackground)
}
