import Foundation

struct Nutrition: Codable, Hashable {
    let kcal: Int
    let carbs: Double // grams
    let protein: Double // grams
    let fat: Double // grams
    let micros: [String: Double] // micronutrients, e.g. ["Mg": 32, "B6": 0.4]
    
    init(kcal: Int, carbs: Double, protein: Double, fat: Double, micros: [String: Double] = [:]) {
        self.kcal = kcal
        self.carbs = carbs
        self.protein = protein
        self.fat = fat
        self.micros = micros
    }
    
    // MARK: - Display Helpers
    var quickFacts: String {
        var facts: [String] = []
        facts.append("\(kcal) calories")
        facts.append("\(Int(carbs))g carbs")
        facts.append("\(Int(protein))g protein")
        facts.append("\(Int(fat))g fat")
        
        // Add key micronutrients
        let keyMicros = ["Mg", "B6", "Ca", "K", "Fe"]
        for micro in keyMicros {
            if let value = micros[micro], value > 0 {
                facts.append("\(Int(value))mg \(micro)")
            }
        }
        
        return facts.joined(separator: " • ")
    }
    
    var keyMicros: [String] {
        let keyMicros = ["Mg", "B6", "Ca", "K", "Fe", "Zn", "C"]
        return keyMicros.compactMap { micro in
            guard let value = micros[micro], value > 0 else { return nil }
            return "\(Int(value))mg \(micro)"
        }
    }
}
