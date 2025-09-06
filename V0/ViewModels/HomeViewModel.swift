import Foundation
import SwiftUI

@MainActor
final class HomeViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var currentState: UserState = .stressed // Mock data
    @Published var rationale: String = "HRV lower vs baseline • Late afternoon dip"
    @Published var showTopThree: Bool = false
    @Published var currentRecommendation: Recommendation? = nil
    @Published var showSnoozeSheet: Bool = false
    @Published var showWhy: Bool = false
    
    // MARK: - Private Properties
    private let service = MockRecommendationService()
    private let settingsStore: SettingsStore
    
    init(settingsStore: SettingsStore = SettingsStore()) {
        self.settingsStore = settingsStore
    }
    
    // MARK: - Public Methods
    func fetchTopThree() {
        var rec = service.recommendation(for: currentState)
        // filter & reassign the foods
        let filtered = service.filtered(rec.foods, using: settingsStore.settings)
        if !filtered.isEmpty {
            rec.foods = filtered
        }
        currentRecommendation = rec
        showTopThree = true
    }
    
    func snooze(minutes: Int) {
        // MVP version: just close popup, future version: schedule suppression in background
        showSnoozeSheet = false
        // TODO: Implement background task scheduling
        print("Snoozed for \(minutes) minutes")
    }
    
    func showWhyThis() {
        showWhy = true
    }
    
    func dismissTopThree() {
        showTopThree = false
        currentRecommendation = nil
    }
    
    func dismissSnoozeSheet() {
        showSnoozeSheet = false
    }
    
    func dismissWhySheet() {
        showWhy = false
    }
    
    // MARK: - State Management
    func updateCurrentState(_ newState: UserState) {
        currentState = newState
        updateRationaleForState(newState)
    }
    
    private func updateRationaleForState(_ state: UserState) {
        switch state {
        case .stressed:
            rationale = "HRV lower vs baseline • Late afternoon dip"
        case .lowEnergy:
            rationale = "Blood sugar levels low • Need quick energy boost"
        case .postWorkout:
            rationale = "Post-workout recovery • Need protein and carbohydrates"
        case .sleepPrep:
            rationale = "Preparing for sleep • Need to promote melatonin secretion"
        case .focusNeeded:
            rationale = "Need to improve focus • Recommend stable blood sugar"
        case .calm:
            rationale = "Relaxed state • Maintain balanced nutrition"
        }
    }
    
    // MARK: - Mock Data for Testing
    func cycleThroughStates() {
        let allStates = UserState.allCases
        if let currentIndex = allStates.firstIndex(of: currentState) {
            let nextIndex = (currentIndex + 1) % allStates.count
            updateCurrentState(allStates[nextIndex])
        }
    }
}
