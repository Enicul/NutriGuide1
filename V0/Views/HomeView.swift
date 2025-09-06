import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel
    
    init(settingsStore: SettingsStore? = nil) {
        _viewModel = StateObject(wrappedValue: HomeViewModel(settingsStore: settingsStore ?? SettingsStore()))
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Main content area
                ScrollView {
                    VStack(spacing: 24) {
                        Spacer(minLength: 40)
                        
                        // App title
                        VStack(spacing: 8) {
                            Text("EatRightNow")
                                .ernTitle()
                                .foregroundColor(.ernAccent)
                            
                            Text("Get personalized food recommendations based on your current state")
                                .ernSubheadline()
                                .multilineTextAlignment(.center)
                        }
                        .padding(.horizontal)
                        
                        // Smart state card
                        SmartStateCard(viewModel: viewModel)
                            .padding(.horizontal)
                        
                        // State switch button (for testing)
                        Button("Switch State (Test)") {
                            viewModel.cycleThroughStates()
                        }
                        .ernTertiary()
                        .padding(.horizontal)
                        
                        Spacer(minLength: 40)
                    }
                }
            }
            .background(Color.ernBackground)
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $viewModel.showTopThree) {
            TopThreeSheet(viewModel: viewModel)
        }
        .sheet(isPresented: $viewModel.showSnoozeSheet) {
            SnoozeSheet(viewModel: viewModel)
        }
        .sheet(isPresented: $viewModel.showWhy) {
            WhySheet(viewModel: viewModel)
        }
    }
}

// MARK: - Snooze Sheet
struct SnoozeSheet: View {
    @ObservedObject var viewModel: HomeViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                VStack(spacing: 12) {
                    Text("Snooze Recommendations")
                        .ernTitle2()
                    
                    Text("Temporarily stop receiving food recommendations")
                        .ernBody()
                        .foregroundColor(.ernTextSecondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top)
                
                VStack(spacing: 16) {
                    SnoozeButton(
                        title: "30 minutes",
                        subtitle: "Short break",
                        action: { viewModel.snooze(minutes: 30) }
                    )
                    
                    SnoozeButton(
                        title: "1 hour",
                        subtitle: "Focus on work",
                        action: { viewModel.snooze(minutes: 60) }
                    )
                    
                    SnoozeButton(
                        title: "2 hours",
                        subtitle: "Extended focus",
                        action: { viewModel.snooze(minutes: 120) }
                    )
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .background(Color.ernBackground)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        viewModel.dismissSnoozeSheet()
                    }
                    .ernTertiary()
                }
            }
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
}

struct SnoozeButton: View {
    let title: String
    let subtitle: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .ernHeadline()
                    Text(subtitle)
                        .ernCaption()
                        .foregroundColor(.ernTextSecondary)
                }
                Spacer()
                ERNIconView(ERNIcon.snooze, color: .ernAccent, size: 20)
            }
            .padding()
            .background(Color.ernCardBackground)
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Why Sheet
struct WhySheet: View {
    @ObservedObject var viewModel: HomeViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Why are these foods recommended?")
                            .ernTitle2()
                        
                        Text("Based on your current state, we recommend the following foods to help you:")
                            .ernBody()
                            .foregroundColor(.ernTextSecondary)
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        WhyPoint(
                            icon: "heart.fill",
                            title: "Scientific Basis",
                            description: "Recommendations based on nutritional science and physiological state analysis"
                        )
                        
                        WhyPoint(
                            icon: "brain.head.profile",
                            title: "Personalized",
                            description: "Adjust recommendations based on your real-time state"
                        )
                        
                        WhyPoint(
                            icon: "leaf.fill",
                            title: "Health First",
                            description: "Prioritize nutritional value and health benefits"
                        )
                    }
                    
                    Spacer(minLength: 40)
                }
                .padding()
            }
            .background(Color.ernBackground)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        viewModel.dismissWhySheet()
                    }
                    .ernTertiary()
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}

struct WhyPoint: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.ernAccent)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .ernHeadline()
                Text(description)
                    .ernBody()
                    .foregroundColor(.ernTextSecondary)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    HomeView()
        .environmentObject(HomeViewModel())
}
