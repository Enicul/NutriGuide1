import SwiftUI

@main
struct EatRightNowApp: App {
    var body: some Scene {
        WindowGroup {
            NutriRootView(viewModel: MockRootViewModel())
        }
    }
}
