import Foundation

struct Food: Identifiable, Hashable, Codable {
    var id = UUID()
    let name: String
    let emoji: String
    let nutrition: Nutrition
    let tags: [String] // e.g. ["vegan", "common"]
    let portionText: String // e.g. "1 medium (120 g)"
    let dietFlags: [String] // e.g. ["Vegan", "Halal"]
    let allergyFlags: [String] // e.g. ["Nut-free"]
    let rationale: String // why this food is recommended
    
    init(name: String, emoji: String, nutrition: Nutrition, tags: [String] = [], portionText: String, dietFlags: [String] = [], allergyFlags: [String] = [], rationale: String = "") {
        self.name = name
        self.emoji = emoji
        self.nutrition = nutrition
        self.tags = tags
        self.portionText = portionText
        self.dietFlags = dietFlags
        self.allergyFlags = allergyFlags
        self.rationale = rationale
    }
    
    // MARK: - Display Helpers
    var displayTags: String {
        tags.joined(separator: " • ")
    }
    
    var displayDietFlags: String {
        dietFlags.joined(separator: " • ")
    }
    
    var displayAllergyFlags: String {
        allergyFlags.joined(separator: " • ")
    }
    
    var hasDietFlags: Bool {
        !dietFlags.isEmpty
    }
    
    var hasAllergyFlags: Bool {
        !allergyFlags.isEmpty
    }
}
