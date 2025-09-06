import SwiftUI

extension Color {
    // MARK: - Background Colors
    static let ernBackground = Color(.systemBackground)
    static let ernCardBackground = Color(.secondarySystemBackground)
    static let ernSurface = Color(.tertiarySystemBackground)
    
    // MARK: - Text Colors
    static let ernTextPrimary = Color(.label)
    static let ernTextSecondary = Color(.secondaryLabel)
    static let ernTextTertiary = Color(.tertiaryLabel)
    
    // MARK: - Accent Colors
    static let ernAccent = Color.blue
    static let ernAccentSecondary = Color.blue.opacity(0.8)
    
    // MARK: - Status Colors
    static let ernSuccess = Color.green
    static let ernWarning = Color.orange
    static let ernError = Color.red
    
    // MARK: - Shadow
    static let ernSurfaceShadow = Color.black.opacity(0.1)
    
    // MARK: - State-specific Colors
    static let ernCalm = Color.mint
    static let ernStressed = Color.orange
    static let ernLowEnergy = Color.yellow
    static let ernPostWorkout = Color.red
    static let ernSleepPrep = Color.purple
    static let ernFocusNeeded = Color.blue
}
