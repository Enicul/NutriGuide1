// This file is self-contained. Rename or integrate according to your project's conventions.

import SwiftUI

// MARK: - Protocol Definition
protocol RootViewModeling: ObservableObject {
    var selectedTab: AppTab { get set }
    var hasUnreadNotifications: Bool { get }
    var isFirstLaunch: Bool { get }
    var showingOnboarding: Bool { get set }
    var appState: AppState { get }
    
    func handleTabSelection(_ tab: AppTab)
    func markNotificationsAsRead()
    func completeOnboarding()
}

// MARK: - Supporting Types
enum AppTab: Int, CaseIterable {
    case home = 0
    case recommendations = 1
    case nearby = 2
    case health = 3
    case sync = 4
    case settings = 5
    
    var title: String {
        switch self {
        case .home: return "Home"
        case .recommendations: return "Nutrition"
        case .nearby: return "Nearby"
        case .health: return "Health"
        case .sync: return "Sync"
        case .settings: return "Settings"
        }
    }
    
    var icon: String {
        switch self {
        case .home: return "house"
        case .recommendations: return "leaf"
        case .nearby: return "location"
        case .health: return "heart"
        case .sync: return "applewatch"
        case .settings: return "gearshape"
        }
    }
    
    var selectedIcon: String {
        switch self {
        case .home: return "house.fill"
        case .recommendations: return "leaf.fill"
        case .nearby: return "location.fill"
        case .health: return "heart.fill"
        case .sync: return "applewatch.radiowaves.left.and.right"
        case .settings: return "gearshape.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .home: return .accentPrimary
        case .recommendations: return .success
        case .nearby: return .warning
        case .health: return .error
        case .sync: return .info
        case .settings: return .textSecondary
        }
    }
}

enum AppState {
    case loading
    case onboarding
    case ready
    case error(String)
}

// MARK: - Mock ViewModel
class MockRootViewModel: RootViewModeling {
    @Published var selectedTab: AppTab = .home
    @Published var hasUnreadNotifications: Bool = true
    @Published var isFirstLaunch: Bool = false
    @Published var showingOnboarding: Bool = false
    @Published var appState: AppState = .ready
    
    func handleTabSelection(_ tab: AppTab) {
        selectedTab = tab
        
        // Mark notifications as read when visiting certain tabs
        if tab == .recommendations || tab == .health {
            hasUnreadNotifications = false
        }
    }
    
    func markNotificationsAsRead() {
        hasUnreadNotifications = false
    }
    
    func completeOnboarding() {
        showingOnboarding = false
        isFirstLaunch = false
        appState = .ready
    }
}

// MARK: - Main Root View
struct NutriRootView<ViewModel: RootViewModeling>: View {
    @StateObject private var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        Group {
            switch viewModel.appState {
            case .loading:
                LoadingView()
            case .onboarding:
                OnboardingView(onComplete: viewModel.completeOnboarding)
            case .ready:
                MainTabView(
                    selectedTab: $viewModel.selectedTab,
                    hasUnreadNotifications: viewModel.hasUnreadNotifications,
                    onTabSelection: viewModel.handleTabSelection
                )
            case .error(let message):
                ErrorView(message: message)
            }
        }
        .onAppear {
            if viewModel.isFirstLaunch {
                viewModel.showingOnboarding = true
            }
        }
        .sheet(isPresented: $viewModel.showingOnboarding) {
            OnboardingView(onComplete: viewModel.completeOnboarding)
                .interactiveDismissDisabled()
        }
    }
}

// MARK: - Main Tab View
struct MainTabView: View {
    @Binding var selectedTab: AppTab
    let hasUnreadNotifications: Bool
    let onTabSelection: (AppTab) -> Void
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Home Tab
            NutriHomeView(viewModel: MockHomeViewModel())
                .tabItem {
                    TabItemView(
                        tab: .home,
                        isSelected: selectedTab == .home,
                        hasNotification: false
                    )
                }
                .tag(AppTab.home)
            
            // Nutritional Recommendations Tab
            NutriRecommendationView(viewModel: MockNutritionalRecommendationViewModel())
                .tabItem {
                    TabItemView(
                        tab: .recommendations,
                        isSelected: selectedTab == .recommendations,
                        hasNotification: hasUnreadNotifications
                    )
                }
                .tag(AppTab.recommendations)
            
            // Nearby Food Tab
            NutriNearbyFoodView(viewModel: MockNearbyFoodViewModel())
                .tabItem {
                    TabItemView(
                        tab: .nearby,
                        isSelected: selectedTab == .nearby,
                        hasNotification: false
                    )
                }
                .tag(AppTab.nearby)
            
            // Health Data Tab
            NutriHealthCardsView(viewModel: MockHealthCardsViewModel())
                .tabItem {
                    TabItemView(
                        tab: .health,
                        isSelected: selectedTab == .health,
                        hasNotification: false
                    )
                }
                .tag(AppTab.health)
            
            // Apple Watch Sync Tab
            NutriSmartwatchSyncView(viewModel: MockSmartwatchSyncViewModel())
                .tabItem {
                    TabItemView(
                        tab: .sync,
                        isSelected: selectedTab == .sync,
                        hasNotification: false
                    )
                }
                .tag(AppTab.sync)
            
            // Settings Tab
            NutriSettingsView(viewModel: MockSettingsViewModel())
                .tabItem {
                    TabItemView(
                        tab: .settings,
                        isSelected: selectedTab == .settings,
                        hasNotification: false
                    )
                }
                .tag(AppTab.settings)
        }
        .onChange(of: selectedTab) { _, newTab in
            onTabSelection(newTab)
        }
        .accentColor(.accentPrimary)
    }
}

// MARK: - Tab Item View
struct TabItemView: View {
    let tab: AppTab
    let isSelected: Bool
    let hasNotification: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                Image(systemName: isSelected ? tab.selectedIcon : tab.icon)
                    .font(.system(size: 22, weight: isSelected ? .semibold : .medium))
                    .foregroundColor(isSelected ? tab.color : .textSecondary)
                
                // Notification badge
                if hasNotification {
                    Circle()
                        .fill(Color.error)
                        .frame(width: 8, height: 8)
                        .offset(x: 12, y: -12)
                }
            }
            
            Text(tab.title)
                .font(.caption2)
                .fontWeight(isSelected ? .semibold : .medium)
                .foregroundColor(isSelected ? tab.color : .textSecondary)
        }
    }
}

// MARK: - Loading View
struct LoadingView: View {
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            Color.backgroundPrimary
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                // App Logo
                ZStack {
                    Circle()
                        .fill(Color.accentPrimary.opacity(0.1))
                        .frame(width: 120, height: 120)
                    
                    Image(systemName: "leaf.fill")
                        .font(.system(size: 48, weight: .medium))
                        .foregroundColor(.accentPrimary)
                        .scaleEffect(isAnimating ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isAnimating)
                }
                
                VStack(spacing: 16) {
                    Text("NutriGuide")
                        .largeTitle()
                        .foregroundColor(.textPrimary)
                    
                    Text("Personalized nutrition for your health")
                        .body()
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.center)
                    
                    ProgressView()
                        .scaleEffect(1.2)
                        .padding(.top, 20)
                }
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}

// MARK: - Onboarding View
struct OnboardingView: View {
    let onComplete: () -> Void
    @State private var currentPage = 0
    
    private let onboardingPages = [
        OnboardingPage(
            icon: "heart.fill",
            title: "Monitor Your Health",
            description: "Connect your Apple Watch to track real-time health metrics including heart rate, stress levels, and activity.",
            color: .error
        ),
        OnboardingPage(
            icon: "leaf.fill",
            title: "Personalized Nutrition",
            description: "Get food recommendations tailored to your current health state, dietary preferences, and nutritional needs.",
            color: .success
        ),
        OnboardingPage(
            icon: "location.fill",
            title: "Find Healthy Options",
            description: "Discover nearby restaurants, cafes, and markets with healthy food options that match your preferences.",
            color: .warning
        ),
        OnboardingPage(
            icon: "brain.head.profile",
            title: "Smart Recommendations",
            description: "Our AI analyzes your health data to provide intelligent food suggestions for optimal nutrition.",
            color: .stateFocusNeeded
        )
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Pages
            TabView(selection: $currentPage) {
                ForEach(Array(onboardingPages.enumerated()), id: \.offset) { index, page in
                    OnboardingPageView(page: page)
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            // Bottom section
            VStack(spacing: 24) {
                // Page indicator
                HStack(spacing: 8) {
                    ForEach(0..<onboardingPages.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? Color.accentPrimary : Color.textTertiary)
                            .frame(width: 8, height: 8)
                            .scaleEffect(index == currentPage ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 0.3), value: currentPage)
                    }
                }
                
                // Navigation buttons
                HStack(spacing: 16) {
                    if currentPage > 0 {
                        Button("Back") {
                            withAnimation(.easeInOut) {
                                currentPage -= 1
                            }
                        }
                        .buttonStyle(SecondaryButtonStyle())
                    } else {
                        Button("Skip") {
                            onComplete()
                        }
                        .buttonStyle(SecondaryButtonStyle())
                    }
                    
                    Button(currentPage == onboardingPages.count - 1 ? "Get Started" : "Next") {
                        if currentPage == onboardingPages.count - 1 {
                            onComplete()
                        } else {
                            withAnimation(.easeInOut) {
                                currentPage += 1
                            }
                        }
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 32)
            .background(Color.backgroundPrimary)
        }
        .background(Color.backgroundPrimary)
    }
}

struct OnboardingPage {
    let icon: String
    let title: String
    let description: String
    let color: Color
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Icon
            ZStack {
                Circle()
                    .fill(page.color.opacity(0.1))
                    .frame(width: 140, height: 140)
                
                Image(systemName: page.icon)
                    .font(.system(size: 56, weight: .medium))
                    .foregroundColor(page.color)
            }
            
            // Content
            VStack(spacing: 20) {
                Text(page.title)
                    .largeTitle()
                    .fontWeight(.bold)
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.center)
                
                Text(page.description)
                    .title3()
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .lineSpacing(4)
            }
            
            Spacer()
        }
        .padding()
    }
}

// MARK: - Error View
struct ErrorView: View {
    let message: String
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 64))
                .foregroundColor(.error)
            
            VStack(spacing: 8) {
                Text("Something went wrong")
                    .title2()
                    .foregroundColor(.textPrimary)
                
                Text(message)
                    .body()
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            Button("Try Again") {
                // Restart app or retry logic
            }
            .buttonStyle(PrimaryButtonStyle())
            .padding(.horizontal, 80)
            
            Spacer()
        }
        .background(Color.backgroundPrimary)
    }
}

// MARK: - App Entry Point Example
struct NutriGuideApp: App {
    var body: some Scene {
        WindowGroup {
            DevicePreview {
                NutriRootView(viewModel: MockRootViewModel())
            }
        }
    }
}

// MARK: - Preview
struct NutriRootView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Main app
            DevicePreview {
                NutriRootView(viewModel: MockRootViewModel())
            }
            .previewDisplayName("Main App")
            
            // Onboarding
            DevicePreview {
                OnboardingView(onComplete: {})
            }
            .previewDisplayName("Onboarding")
            
            // Loading
            DevicePreview {
                LoadingView()
            }
            .previewDisplayName("Loading")
        }
        .previewDevice("iPhone 15 Pro")
    }
}
