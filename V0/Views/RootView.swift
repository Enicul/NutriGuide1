import SwiftUI

struct RootView: View {
    @StateObject private var settingsStore = SettingsStore()
    
    var body: some View {
        TabView {
            HomeView(settingsStore: settingsStore)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            SettingsView(vm: SettingsViewModel(store: settingsStore))
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
    }
}

#Preview {
    RootView()
}
