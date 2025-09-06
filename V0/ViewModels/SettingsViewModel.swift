import Foundation

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var settingsStore: SettingsStore
    
    init(store: SettingsStore = SettingsStore()) {
        self.settingsStore = store
    }
    
    var preferences: Set<DietaryPreference> {
        get { settingsStore.settings.preferences }
        set { settingsStore.settings.preferences = newValue }
    }
    
    var allergies: Set<Allergy> {
        get { settingsStore.settings.allergies }
        set { settingsStore.settings.allergies = newValue }
    }
    
    var pantry: [PantryItem] {
        get { settingsStore.settings.pantry }
        set { settingsStore.settings.pantry = newValue }
    }
    
    func togglePreference(_ pref: DietaryPreference) {
        if preferences.contains(pref) {
            preferences.remove(pref)
        } else {
            preferences.insert(pref)
        }
    }
    
    func toggleAllergy(_ allergy: Allergy) {
        if allergies.contains(allergy) {
            allergies.remove(allergy)
        } else {
            allergies.insert(allergy)
        }
    }
    
    func togglePantry(_ item: PantryItem) {
        var list = pantry
        if let idx = list.firstIndex(of: item) {
            list[idx].enabled.toggle()
            pantry = list
        }
    }
}
