import Foundation
import SwiftUI

enum UserState: String, CaseIterable, Identifiable, Codable {
    case calm = "calm"
    case stressed = "stressed"
    case lowEnergy = "lowEnergy"
    case postWorkout = "postWorkout"
    case sleepPrep = "sleepPrep"
    case focusNeeded = "focusNeeded"
    
    var id: String { rawValue }
    
    // MARK: - Display Properties
    var displayName: String {
        switch self {
        case .calm:
            return "Calm"
        case .stressed:
            return "Stressed"
        case .lowEnergy:
            return "Low Energy"
        case .postWorkout:
            return "Post Workout"
        case .sleepPrep:
            return "Sleep Prep"
        case .focusNeeded:
            return "Focus Needed"
        }
    }
    
    var iconName: String {
        switch self {
        case .calm:
            return ERNIcon.calm
        case .stressed:
            return ERNIcon.stressed
        case .lowEnergy:
            return ERNIcon.lowEnergy
        case .postWorkout:
            return ERNIcon.postWorkout
        case .sleepPrep:
            return ERNIcon.sleepPrep
        case .focusNeeded:
            return ERNIcon.focusNeeded
        }
    }
    
    var color: Color {
        switch self {
        case .calm:
            return .ernCalm
        case .stressed:
            return .ernStressed
        case .lowEnergy:
            return .ernLowEnergy
        case .postWorkout:
            return .ernPostWorkout
        case .sleepPrep:
            return .ernSleepPrep
        case .focusNeeded:
            return .ernFocusNeeded
        }
    }
    
    var description: String {
        switch self {
        case .calm:
            return "Relaxed and in good condition"
        case .stressed:
            return "Feeling stressed, need relief"
        case .lowEnergy:
            return "Low energy, need replenishment"
        case .postWorkout:
            return "Post-workout recovery period"
        case .sleepPrep:
            return "Preparing for sleep, need sleep aid"
        case .focusNeeded:
            return "Need to improve focus"
        }
    }
}
