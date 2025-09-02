import Foundation

enum Allergy: String, CaseIterable, Codable, Hashable, Identifiable {
    case dairy, nuts, gluten, egg, soy, shellfish
    
    var id: String { rawValue }
    
    var label: String {
        switch self {
        case .dairy: "Dairy"
        case .nuts: "Nuts"
        case .gluten: "Gluten"
        case .egg: "Egg"
        case .soy: "Soy"
        case .shellfish: "Shellfish"
        }
    }
}
