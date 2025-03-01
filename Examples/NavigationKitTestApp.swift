import SwiftUI
import NavigationKit

@main
struct NavigationKitDemoApp: App {
    // NavigationManager должен быть StateObject
    @StateObject private var navigationManager = NavigationKit.createNavigationManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .withNavigationManager(navigationManager)
        }
    }
}
