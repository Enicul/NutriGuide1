import Foundation

enum DietaryPreference: String, CaseIterable, Codable, Hashable, Identifiable {
    case vegan, vegetarian, halal, kosher, dairyFree, glutenFree, nutFree
    
    var id: String { rawValue }
    
    var label: String {
        switch self {
        case .vegan: "Vegan"
        case .vegetarian: "Vegetarian"
        case .halal: "Halal"
        case .kosher: "Kosher"
        case .dairyFree: "Dairy-free"
        case .glutenFree: "Gluten-free"
        case .nutFree: "Nut-free"
        }
    }
}
