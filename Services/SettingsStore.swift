import Foundation

struct UserSettings: Codable, Equatable {
    var preferences: Set<DietaryPreference> = []
    var allergies: Set<Allergy> = []
    var pantry: [PantryItem] = []
}

final class SettingsStore: ObservableObject {
    @Published var settings: UserSettings {
        didSet { persist() }
    }
    
    private let key = "ERN.UserSettings.v1"
    
    init() {
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode(UserSettings.self, from: data) {
            self.settings = decoded
        } else {
            self.settings = UserSettings(
                preferences: [],
                allergies: [],
                pantry: [
                    .init(name: "Banana", emoji: "🍌", enabled: true),
                    .init(name: "Dark Chocolate (70%+)", emoji: "🍫", enabled: false),
                    .init(name: "Yogurt", emoji: "🥣", enabled: true),
                    .init(name: "Oats", emoji: "🥣", enabled: true),
                    .init(name: "Apple", emoji: "🍎", enabled: true),
                    .init(name: "Greek Yogurt", emoji: "🥛", enabled: true),
                    .init(name: "Eggs", emoji: "🥚", enabled: false),
                    .init(name: "Nuts", emoji: "🥜", enabled: false)
                ]
            )
            persist()
        }
    }
    
    private func persist() {
        if let data = try? JSONEncoder().encode(settings) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
