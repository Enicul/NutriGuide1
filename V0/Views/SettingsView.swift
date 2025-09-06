import SwiftUI

struct SettingsView: View {
    @StateObject var vm = SettingsViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                Section("Dietary Preferences") {
                    FlexibleChipGrid(
                        items: DietaryPreference.allCases,
                        isSelected: { vm.preferences.contains($0) }
                    ) { item in
                        TagChip(
                            text: item.label,
                            isSelected: vm.preferences.contains(item)
                        ) {
                            vm.togglePreference(item)
                        }
                    }
                    .listRowInsets(EdgeInsets())
                }
                
                Section("Allergies") {
                    FlexibleChipGrid(
                        items: Allergy.allCases,
                        isSelected: { vm.allergies.contains($0) }
                    ) { item in
                        TagChip(
                            text: item.label,
                            isSelected: vm.allergies.contains(item)
                        ) {
                            vm.toggleAllergy(item)
                        }
                    }
                    .listRowInsets(EdgeInsets())
                }
                
                Section("Pantry") {
                    ForEach(vm.pantry) { item in
                        Toggle(isOn: Binding(
                            get: { item.enabled },
                            set: { _ in vm.togglePantry(item) }
                        )) {
                            HStack(spacing: 8) {
                                Text(item.emoji)
                                Text(item.name)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

// Simple flexible chip grid for tags
struct FlexibleChipGrid<Item: Hashable & Identifiable, Label: View>: View {
    let items: [Item]
    var isSelected: (Item) -> Bool
    let label: (Item) -> Label
    
    init(
        items: [Item],
        isSelected: @escaping (Item) -> Bool,
        @ViewBuilder label: @escaping (Item) -> Label
    ) {
        self.items = items
        self.isSelected = isSelected
        self.label = label
    }
    
    var body: some View {
        LazyVGrid(
            columns: [GridItem(.adaptive(minimum: 110), spacing: 8)],
            spacing: 8
        ) {
            ForEach(items) { item in
                label(item)
            }
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 8)
        .background(Color.clear)
    }
}

#Preview {
    SettingsView()
}
