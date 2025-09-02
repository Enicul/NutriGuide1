import Foundation

struct PantryItem: Identifiable, Codable, Hashable {
    var id = UUID()
    var name: String
    var emoji: String
    var enabled: Bool
}
