import Foundation

struct Recommendation: Identifiable, Codable {
    var id = UUID()
    let state: UserState
    let reason: String // e.g. "HRV lower vs baseline; suggest Mg + B6 for relaxation"
    var foods: [Food] // Top 3
    
    init(state: UserState, reason: String, foods: [Food]) {
        self.state = state
        self.reason = reason
        self.foods = foods
    }
    
    // MARK: - Display Helpers
    var title: String {
        "Top 3 for \(state.displayName)"
    }
    
    var shortReason: String {
        // Take first two sentences or limit length
        let sentences = reason.components(separatedBy: "•")
        if sentences.count > 1 {
            return sentences.prefix(2).joined(separator: " • ")
        }
        
        if reason.count > 60 {
            return String(reason.prefix(57)) + "..."
        }
        
        return reason
    }
}
