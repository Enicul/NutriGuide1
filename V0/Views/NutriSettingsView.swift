// This file is self-contained. Rename or integrate according to your project's conventions.

import SwiftUI

// MARK: - Protocol Definition
protocol SettingsViewModeling: ObservableObject {
    var userProfile: UserProfile { get set }
    var dietaryPreferences: Set<DietaryPreference> { get set }
    var allergies: Set<Allergy> { get set }
    var notificationSettings: NotificationSettings { get set }
    var privacySettings: PrivacySettings { get set }
    var appSettings: AppSettings { get set }
    var isLoading: Bool { get }
    
    func saveSettings()
    func resetToDefaults()
    func exportUserData()
    func deleteAllData()
}

// MARK: - Supporting Types
struct UserProfile {
    var name: String
    var age: Int
    var weight: Double // kg
    var height: Double // cm
    var activityLevel: ActivityLevel
    var healthGoals: Set<HealthGoal>
    
    enum ActivityLevel: String, CaseIterable {
        case sedentary = "Sedentary"
        case lightlyActive = "Lightly Active"
        case moderatelyActive = "Moderately Active"
        case veryActive = "Very Active"
        case extremelyActive = "Extremely Active"
        
        var description: String {
            switch self {
            case .sedentary: return "Little to no exercise"
            case .lightlyActive: return "Light exercise 1-3 days/week"
            case .moderatelyActive: return "Moderate exercise 3-5 days/week"
            case .veryActive: return "Hard exercise 6-7 days/week"
            case .extremelyActive: return "Very hard exercise, 2x/day"
            }
        }
        
        var icon: String {
            switch self {
            case .sedentary: return "figure.seated.side"
            case .lightlyActive: return "figure.walk"
            case .moderatelyActive: return "figure.run"
            case .veryActive: return "figure.strengthtraining.traditional"
            case .extremelyActive: return "figure.boxing"
            }
        }
    }
    
    enum HealthGoal: String, CaseIterable {
        case weightLoss = "Weight Loss"
        case weightGain = "Weight Gain"
        case muscleGain = "Muscle Gain"
        case improvedEnergy = "Improved Energy"
        case betterSleep = "Better Sleep"
        case stressReduction = "Stress Reduction"
        case immuneSupport = "Immune Support"
        case heartHealth = "Heart Health"
        case brainHealth = "Brain Health"
        case digestiveHealth = "Digestive Health"
        
        var icon: String {
            switch self {
            case .weightLoss: return "minus.circle"
            case .weightGain: return "plus.circle"
            case .muscleGain: return "figure.strengthtraining.traditional"
            case .improvedEnergy: return "bolt.fill"
            case .betterSleep: return "moon.fill"
            case .stressReduction: return "brain.head.profile"
            case .immuneSupport: return "shield.fill"
            case .heartHealth: return "heart.fill"
            case .brainHealth: return "brain"
            case .digestiveHealth: return "stomach"
            }
        }
        
        var color: Color {
            switch self {
            case .weightLoss: return .error
            case .weightGain: return .success
            case .muscleGain: return .statePostWorkout
            case .improvedEnergy: return .stateLowEnergy
            case .betterSleep: return .stateSleepPrep
            case .stressReduction: return .stateStressed
            case .immuneSupport: return .accentPrimary
            case .heartHealth: return .error
            case .brainHealth: return .stateFocusNeeded
            case .digestiveHealth: return .success
            }
        }
    }
}

enum DietaryPreference: String, CaseIterable {
    case vegetarian = "Vegetarian"
    case vegan = "Vegan"
    case pescatarian = "Pescatarian"
    case keto = "Ketogenic"
    case paleo = "Paleo"
    case mediterranean = "Mediterranean"
    case lowCarb = "Low Carb"
    case lowFat = "Low Fat"
    case glutenFree = "Gluten-Free"
    case dairyFree = "Dairy-Free"
    case halal = "Halal"
    case kosher = "Kosher"
    
    var icon: String {
        switch self {
        case .vegetarian, .vegan: return "leaf.fill"
        case .pescatarian: return "fish.fill"
        case .keto, .lowCarb: return "flame.fill"
        case .paleo: return "mountain.2.fill"
        case .mediterranean: return "sun.max.fill"
        case .lowFat: return "drop.fill"
        case .glutenFree: return "grain"
        case .dairyFree: return "drop.triangle.fill"
        case .halal, .kosher: return "star.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .vegetarian, .vegan: return .success
        case .pescatarian: return .info
        case .keto, .lowCarb: return .warning
        case .paleo: return .statePostWorkout
        case .mediterranean: return .warning
        case .lowFat: return .accentPrimary
        case .glutenFree: return .stateStressed
        case .dairyFree: return .stateSleepPrep
        case .halal, .kosher: return .accentPrimary
        }
    }
}

enum Allergy: String, CaseIterable {
    case nuts = "Tree Nuts"
    case peanuts = "Peanuts"
    case dairy = "Dairy"
    case eggs = "Eggs"
    case soy = "Soy"
    case wheat = "Wheat"
    case fish = "Fish"
    case shellfish = "Shellfish"
    case sesame = "Sesame"
    
    var icon: String {
        switch self {
        case .nuts: return "tree.fill"
        case .peanuts: return "circle.fill"
        case .dairy: return "drop.triangle.fill"
        case .eggs: return "oval.fill"
        case .soy: return "leaf.arrow.circlepath"
        case .wheat: return "grain"
        case .fish: return "fish.fill"
        case .shellfish: return "tortoise.fill"
        case .sesame: return "circle.dotted"
        }
    }
}

struct NotificationSettings {
    var recommendationsEnabled: Bool
    var mealRemindersEnabled: Bool
    var syncRemindersEnabled: Bool
    var weeklyReportsEnabled: Bool
    var recommendationTime: Date
    var breakfastTime: Date
    var lunchTime: Date
    var dinnerTime: Date
    var quietHoursEnabled: Bool
    var quietHoursStart: Date
    var quietHoursEnd: Date
}

struct PrivacySettings {
    var dataAnalyticsEnabled: Bool
    var crashReportingEnabled: Bool
    var locationServicesEnabled: Bool
    var healthDataSharingEnabled: Bool
    var personalizedAdsEnabled: Bool
}

struct AppSettings {
    var theme: AppTheme
    var measurementUnits: MeasurementUnits
    var languageCode: String
    var autoSyncEnabled: Bool
    var cacheLifetime: CacheLifetime
    
    enum AppTheme: String, CaseIterable {
        case system = "System"
        case light = "Light"
        case dark = "Dark"
        
        var icon: String {
            switch self {
            case .system: return "circle.lefthalf.filled"
            case .light: return "sun.max.fill"
            case .dark: return "moon.fill"
            }
        }
    }
    
    enum MeasurementUnits: String, CaseIterable {
        case metric = "Metric"
        case imperial = "Imperial"
        
        var description: String {
            switch self {
            case .metric: return "kg, cm, °C"
            case .imperial: return "lbs, ft/in, °F"
            }
        }
    }
    
    enum CacheLifetime: String, CaseIterable {
        case short = "1 hour"
        case medium = "4 hours"
        case long = "24 hours"
        case extended = "1 week"
    }
}

// MARK: - Mock ViewModel
class MockSettingsViewModel: SettingsViewModeling {
    @Published var userProfile = UserProfile(
        name: "John Doe",
        age: 32,
        weight: 75.0,
        height: 180.0,
        activityLevel: .moderatelyActive,
        healthGoals: [.improvedEnergy, .betterSleep]
    )
    
    @Published var dietaryPreferences: Set<DietaryPreference> = [.vegetarian, .glutenFree]
    @Published var allergies: Set<Allergy> = [.nuts, .dairy]
    
    @Published var notificationSettings = NotificationSettings(
        recommendationsEnabled: true,
        mealRemindersEnabled: true,
        syncRemindersEnabled: false,
        weeklyReportsEnabled: true,
        recommendationTime: Calendar.current.date(from: DateComponents(hour: 9, minute: 0)) ?? Date(),
        breakfastTime: Calendar.current.date(from: DateComponents(hour: 7, minute: 30)) ?? Date(),
        lunchTime: Calendar.current.date(from: DateComponents(hour: 12, minute: 30)) ?? Date(),
        dinnerTime: Calendar.current.date(from: DateComponents(hour: 18, minute: 30)) ?? Date(),
        quietHoursEnabled: true,
        quietHoursStart: Calendar.current.date(from: DateComponents(hour: 22, minute: 0)) ?? Date(),
        quietHoursEnd: Calendar.current.date(from: DateComponents(hour: 7, minute: 0)) ?? Date()
    )
    
    @Published var privacySettings = PrivacySettings(
        dataAnalyticsEnabled: true,
        crashReportingEnabled: true,
        locationServicesEnabled: true,
        healthDataSharingEnabled: false,
        personalizedAdsEnabled: false
    )
    
    @Published var appSettings = AppSettings(
        theme: .system,
        measurementUnits: .metric,
        languageCode: "en",
        autoSyncEnabled: true,
        cacheLifetime: .medium
    )
    
    @Published var isLoading = false
    
    func saveSettings() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isLoading = false
        }
    }
    
    func resetToDefaults() {
        // Reset all settings to defaults
        userProfile = UserProfile(
            name: "",
            age: 25,
            weight: 70.0,
            height: 170.0,
            activityLevel: .moderatelyActive,
            healthGoals: []
        )
        dietaryPreferences.removeAll()
        allergies.removeAll()
        // Reset other settings...
    }
    
    func exportUserData() {
        // Export user data logic
    }
    
    func deleteAllData() {
        // Delete all user data logic
    }
}

// MARK: - Main Settings View
struct NutriSettingsView<ViewModel: SettingsViewModeling>: View {
    @StateObject private var viewModel: ViewModel
    @State private var showingDeleteAlert = false
    @State private var showingResetAlert = false
    
    init(viewModel: ViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            List {
                // User Profile Section
                Section("Profile") {
                    NavigationLink {
                        UserProfileView(profile: $viewModel.userProfile)
                    } label: {
                        SettingsRowView(
                            icon: "person.circle.fill",
                            title: "Personal Information",
                            subtitle: viewModel.userProfile.name.isEmpty ? "Tap to set up" : viewModel.userProfile.name,
                            color: .accentPrimary
                        )
                    }
                }
                
                // Dietary Preferences Section
                Section("Dietary Preferences") {
                    NavigationLink {
                        DietaryPreferencesView(
                            preferences: $viewModel.dietaryPreferences,
                            allergies: $viewModel.allergies
                        )
                    } label: {
                        SettingsRowView(
                            icon: "leaf.fill",
                            title: "Diet & Allergies",
                            subtitle: "\(viewModel.dietaryPreferences.count) preferences, \(viewModel.allergies.count) allergies",
                            color: .success
                        )
                    }
                }
                
                // Notifications Section
                Section("Notifications") {
                    NavigationLink {
                        NotificationSettingsView(settings: $viewModel.notificationSettings)
                    } label: {
                        SettingsRowView(
                            icon: "bell.fill",
                            title: "Notifications",
                            subtitle: viewModel.notificationSettings.recommendationsEnabled ? "Enabled" : "Disabled",
                            color: .warning
                        )
                    }
                }
                
                // Privacy Section
                Section("Privacy & Data") {
                    NavigationLink {
                        PrivacySettingsView(settings: $viewModel.privacySettings)
                    } label: {
                        SettingsRowView(
                            icon: "shield.fill",
                            title: "Privacy",
                            subtitle: "Manage data usage",
                            color: .error
                        )
                    }
                    
                    Button {
                        viewModel.exportUserData()
                    } label: {
                        SettingsRowView(
                            icon: "square.and.arrow.up",
                            title: "Export Data",
                            subtitle: "Download your information",
                            color: .accentPrimary
                        )
                    }
                }
                
                // App Settings Section
                Section("App Settings") {
                    NavigationLink {
                        AppSettingsView(settings: $viewModel.appSettings)
                    } label: {
                        SettingsRowView(
                            icon: "gearshape.fill",
                            title: "General",
                            subtitle: "Theme, units, language",
                            color: .textSecondary
                        )
                    }
                }
                
                // Support Section
                Section("Support") {
                    Button {
                        // Open help
                    } label: {
                        SettingsRowView(
                            icon: "questionmark.circle.fill",
                            title: "Help & FAQ",
                            subtitle: "Get support",
                            color: .info
                        )
                    }
                    
                    Button {
                        // Open feedback
                    } label: {
                        SettingsRowView(
                            icon: "envelope.fill",
                            title: "Send Feedback",
                            subtitle: "Help us improve",
                            color: .accentPrimary
                        )
                    }
                }
                
                // Danger Zone
                Section("Danger Zone") {
                    Button {
                        showingResetAlert = true
                    } label: {
                        SettingsRowView(
                            icon: "arrow.clockwise.circle.fill",
                            title: "Reset Settings",
                            subtitle: "Restore defaults",
                            color: .warning
                        )
                    }
                    
                    Button {
                        showingDeleteAlert = true
                    } label: {
                        SettingsRowView(
                            icon: "trash.fill",
                            title: "Delete All Data",
                            subtitle: "Permanently remove all data",
                            color: .error
                        )
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        viewModel.saveSettings()
                    }
                    .disabled(viewModel.isLoading)
                }
            }
        }
        .alert("Reset Settings", isPresented: $showingResetAlert) {
            Button("Reset", role: .destructive) {
                viewModel.resetToDefaults()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will reset all settings to their default values. This action cannot be undone.")
        }
        .alert("Delete All Data", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                viewModel.deleteAllData()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will permanently delete all your data including profile, preferences, and history. This action cannot be undone.")
        }
    }
}

// MARK: - Settings Row View
struct SettingsRowView: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 32, height: 32)
                .background(color.opacity(0.1))
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .headline()
                    .foregroundColor(.textPrimary)
                
                Text(subtitle)
                    .caption()
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
    }
}

// MARK: - User Profile View
struct UserProfileView: View {
    @Binding var profile: UserProfile
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Personal Information") {
                    TextField("Full Name", text: $profile.name)
                        .textContentType(.name)
                    
                    HStack {
                        Text("Age")
                        Spacer()
                        TextField("Age", value: $profile.age, format: .number)
                            .keyboardType(.numberPad)
                            .frame(width: 60)
                            .multilineTextAlignment(.trailing)
                        Text("years")
                            .foregroundColor(.textSecondary)
                    }
                    
                    HStack {
                        Text("Weight")
                        Spacer()
                        TextField("Weight", value: $profile.weight, format: .number.precision(.fractionLength(1)))
                            .keyboardType(.decimalPad)
                            .frame(width: 80)
                            .multilineTextAlignment(.trailing)
                        Text("kg")
                            .foregroundColor(.textSecondary)
                    }
                    
                    HStack {
                        Text("Height")
                        Spacer()
                        TextField("Height", value: $profile.height, format: .number.precision(.fractionLength(0)))
                            .keyboardType(.numberPad)
                            .frame(width: 80)
                            .multilineTextAlignment(.trailing)
                        Text("cm")
                            .foregroundColor(.textSecondary)
                    }
                }
                
                Section("Activity Level") {
                    Picker("Activity Level", selection: $profile.activityLevel) {
                        ForEach(UserProfile.ActivityLevel.allCases, id: \.self) { level in
                            VStack(alignment: .leading) {
                                Text(level.rawValue)
                                Text(level.description)
                                    .font(.caption)
                                    .foregroundColor(.textSecondary)
                            }
                            .tag(level)
                        }
                    }
                    .pickerStyle(.automatic)
                }
                
                Section("Health Goals") {
                    ForEach(UserProfile.HealthGoal.allCases, id: \.self) { goal in
                        HStack {
                            Image(systemName: goal.icon)
                                .foregroundColor(goal.color)
                                .frame(width: 24)
                            
                            Text(goal.rawValue)
                            
                            Spacer()
                            
                            if profile.healthGoals.contains(goal) {
                                Image(systemName: SystemIcon.checkmark)
                                    .foregroundColor(.accentPrimary)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if profile.healthGoals.contains(goal) {
                                profile.healthGoals.remove(goal)
                            } else {
                                profile.healthGoals.insert(goal)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Dietary Preferences View
struct DietaryPreferencesView: View {
    @Binding var preferences: Set<DietaryPreference>
    @Binding var allergies: Set<Allergy>
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Section("Dietary Preferences") {
                    ForEach(DietaryPreference.allCases, id: \.self) { preference in
                        HStack {
                            Image(systemName: preference.icon)
                                .foregroundColor(preference.color)
                                .frame(width: 24)
                            
                            Text(preference.rawValue)
                            
                            Spacer()
                            
                            if preferences.contains(preference) {
                                Image(systemName: SystemIcon.checkmark)
                                    .foregroundColor(.accentPrimary)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if preferences.contains(preference) {
                                preferences.remove(preference)
                            } else {
                                preferences.insert(preference)
                            }
                        }
                    }
                }
                
                Section("Allergies & Intolerances") {
                    ForEach(Allergy.allCases, id: \.self) { allergy in
                        HStack {
                            Image(systemName: allergy.icon)
                                .foregroundColor(.error)
                                .frame(width: 24)
                            
                            Text(allergy.rawValue)
                            
                            Spacer()
                            
                            if allergies.contains(allergy) {
                                Image(systemName: SystemIcon.checkmark)
                                    .foregroundColor(.accentPrimary)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if allergies.contains(allergy) {
                                allergies.remove(allergy)
                            } else {
                                allergies.insert(allergy)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Diet & Allergies")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Notification Settings View
struct NotificationSettingsView: View {
    @Binding var settings: NotificationSettings
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Notification Types") {
                    Toggle("Food Recommendations", isOn: $settings.recommendationsEnabled)
                    Toggle("Meal Reminders", isOn: $settings.mealRemindersEnabled)
                    Toggle("Sync Reminders", isOn: $settings.syncRemindersEnabled)
                    Toggle("Weekly Reports", isOn: $settings.weeklyReportsEnabled)
                }
                
                Section("Timing") {
                    DatePicker("Recommendation Time", selection: $settings.recommendationTime, displayedComponents: .hourAndMinute)
                    DatePicker("Breakfast", selection: $settings.breakfastTime, displayedComponents: .hourAndMinute)
                    DatePicker("Lunch", selection: $settings.lunchTime, displayedComponents: .hourAndMinute)
                    DatePicker("Dinner", selection: $settings.dinnerTime, displayedComponents: .hourAndMinute)
                }
                
                Section("Quiet Hours") {
                    Toggle("Enable Quiet Hours", isOn: $settings.quietHoursEnabled)
                    
                    if settings.quietHoursEnabled {
                        DatePicker("Start", selection: $settings.quietHoursStart, displayedComponents: .hourAndMinute)
                        DatePicker("End", selection: $settings.quietHoursEnd, displayedComponents: .hourAndMinute)
                    }
                }
            }
            .navigationTitle("Notifications")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Privacy Settings View
struct PrivacySettingsView: View {
    @Binding var settings: PrivacySettings
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Data Collection") {
                    Toggle("Analytics", isOn: $settings.dataAnalyticsEnabled)
                    Toggle("Crash Reporting", isOn: $settings.crashReportingEnabled)
                    Toggle("Location Services", isOn: $settings.locationServicesEnabled)
                }
                
                Section("Data Sharing") {
                    Toggle("Health Data Sharing", isOn: $settings.healthDataSharingEnabled)
                    Toggle("Personalized Ads", isOn: $settings.personalizedAdsEnabled)
                }
                
                Section("Information") {
                    Button("Privacy Policy") {
                        // Open privacy policy
                    }
                    
                    Button("Terms of Service") {
                        // Open terms
                    }
                }
            }
            .navigationTitle("Privacy")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - App Settings View
struct AppSettingsView: View {
    @Binding var settings: AppSettings
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Appearance") {
                    Picker("Theme", selection: $settings.theme) {
                        ForEach(AppSettings.AppTheme.allCases, id: \.self) { theme in
                            HStack {
                                Image(systemName: theme.icon)
                                Text(theme.rawValue)
                            }
                            .tag(theme)
                        }
                    }
                }
                
                Section("Units") {
                    Picker("Measurement Units", selection: $settings.measurementUnits) {
                        ForEach(AppSettings.MeasurementUnits.allCases, id: \.self) { unit in
                            VStack(alignment: .leading) {
                                Text(unit.rawValue)
                                Text(unit.description)
                                    .font(.caption)
                                    .foregroundColor(.textSecondary)
                            }
                            .tag(unit)
                        }
                    }
                }
                
                Section("Sync & Storage") {
                    Toggle("Auto Sync", isOn: $settings.autoSyncEnabled)
                    
                    Picker("Cache Lifetime", selection: $settings.cacheLifetime) {
                        ForEach(AppSettings.CacheLifetime.allCases, id: \.self) { lifetime in
                            Text(lifetime.rawValue).tag(lifetime)
                        }
                    }
                }
            }
            .navigationTitle("General")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Preview
struct NutriSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        DevicePreview {
            NutriSettingsView(viewModel: MockSettingsViewModel())
        }
        .previewDevice("iPhone 15 Pro")
    }
}
