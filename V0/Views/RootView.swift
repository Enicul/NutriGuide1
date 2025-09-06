import SwiftUI

struct RootView: View {
    @StateObject private var settingsStore = SettingsStore()
    @State private var showingSyncView = false
    
    var body: some View {
        TabView {
            HomeView(settingsStore: settingsStore)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            SmartwatchSyncView()
                .tabItem {
                    Label("Sync", systemImage: "applewatch")
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
