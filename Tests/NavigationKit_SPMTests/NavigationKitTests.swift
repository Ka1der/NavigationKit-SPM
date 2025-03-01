//
//  NavigationKitTests.swift
//  NavigationKitTests
//
//  Created by Kaider on 01.03.2025.
//

import XCTest
@testable import NavigationKit

@MainActor
final class NavigationKitTests: XCTestCase {
    
    // Тест создания NavigationManager
    @MainActor func testCreateNavigationManager() async {
        let navigationManager = NavigationKit.createNavigationManager()
        XCTAssertNotNil(navigationManager, "NavigationKit должен создавать экземпляр NavigationManager")
    }
    
    // Тест версии фреймворка
    func testVersion() {
        XCTAssertEqual(NavigationKit.version, "1.0.0", "Версия NavigationKit должна быть 1.0.0")
    }
    
    // Тест информации о фреймворке
    func testInfo() {
        let expectedInfo = """
            NavigationKit 1.0.0
            A modern SwiftUI navigation framework.
            """
        XCTAssertEqual(NavigationKit.info, expectedInfo, "Информация о NavigationKit должна соответствовать ожидаемой")
    }
}
