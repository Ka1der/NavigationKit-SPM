//
//  ViewExtensionsTests.swift
//  NavigationKitTests
//
//  Created by Kaider on 01.03.2025.
//

import XCTest
import SwiftUI
@testable import NavigationKit

@MainActor
final class ViewExtensionsTests: XCTestCase {
    
    enum TestScreen: Screen, Hashable, Identifiable {
        case main
        case details(id: Int)
        
        // Протокол Screen
        var body: some View {
            switch self {
            case .main:
                Text("Main")
            case .details(let id):
                Text("Details \(id)")
            }
        }
        
        // Протокол Identifiable
        var id: String {
            switch self {
            case .main:
                return "main"
            case .details(let value):
                return "details-\(value)"
            }
        }
    }
    
    var navigationManager: NavigationManager!
    
    @MainActor override func setUp() {
        super.setUp()
        navigationManager = NavigationKit.createNavigationManager()
    }
    
    @MainActor override func tearDown() {
        navigationManager = nil
        super.tearDown()
    }
    
    // Тест расширения withNavigationManager
    @MainActor func testWithNavigationManager() async {
        let view = Text("Test View").withNavigationManager(navigationManager)
        XCTAssertNotNil(view)
    }
    
    // Тест расширения withNavigationContainer
    @MainActor func testWithNavigationContainer() async {
        let view = Text("Test View").withNavigationContainer(
            navigationManager: navigationManager,
            rootView: { Text("Root View") },
            destinationBuilder: { (screen: TestScreen) in screen.body }
        )
        XCTAssertNotNil(view)
    }
    
    // Тест расширения withNavigationModals
    @MainActor func testWithNavigationModals() async {
        let view = Text("Test View").withNavigationModals(
            navigationManager: navigationManager,
            sheetContent: { (screen: TestScreen) in screen.body },
            fullScreenCoverContent: { (screen: TestScreen) in screen.body }
        )
        XCTAssertNotNil(view)
        
        navigationManager.presentSheet(TestScreen.details(id: 1))
        XCTAssertNotNil(navigationManager.activeSheet)
    }
}
