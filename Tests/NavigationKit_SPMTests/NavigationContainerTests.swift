//
//  NavigationContainerTests.swift
//  NavigationKitTests
//
//  Created by Kaider on 01.03.2025.
//

import XCTest
import SwiftUI
@testable import NavigationKit

@MainActor
final class NavigationContainerTests: XCTestCase {
    
    enum TestScreen: Screen, Hashable {
        case main
        case details(id: Int)
        case settings
        
        var body: some View {
            switch self {
            case .main:
                Text("Main")
            case .details(let id):
                Text("Details \(id)")
            case .settings:
                Text("Settings")
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
    
    // Тест создания NavigationContainer
    @MainActor func testNavigationContainerInitialization() async {
        // Создание контейнера
        let container = NavigationContainer(
            navigationManager: navigationManager,
            rootView: { Text("Root") },
            destinationBuilder: { (screen: TestScreen) in screen.body }
        )
        
        // Проверяем, что контейнер успешно создан
        XCTAssertNotNil(container, "NavigationContainer должен успешно инициализироваться")
    }
    
    // Тест синхронизации пути навигации
    @MainActor func testNavigationPathBinding() async {
        // Добавляем экраны в путь навигации
        navigationManager.navigate(to: TestScreen.details(id: 1))
        navigationManager.navigate(to: TestScreen.settings)
        
        // Проверяем состояние пути навигации
        XCTAssertEqual(navigationManager.path.count, 2, "Путь навигации должен содержать 2 экрана")
        
        // Очищаем путь навигации
        navigationManager.path.removeLast(navigationManager.path.count)
        
        // Проверяем, что путь пуст
        XCTAssertEqual(navigationManager.path.count, 0, "Путь навигации должен быть пустым после удаления всех экранов")
    }
    
    // Тест взаимодействия NavigationContainer с модальными представлениями
    @MainActor func testNavigationContainerWithModals() async {
        // Проверка начального состояния
        XCTAssertNil(navigationManager.activeSheet, "activeSheet должен быть nil изначально")
        XCTAssertNil(navigationManager.activeFullScreenCover, "activeFullScreenCover должен быть nil изначально")
        
        // Открытие модального окна
        navigationManager.presentSheet(TestScreen.settings)
        XCTAssertNotNil(navigationManager.activeSheet, "activeSheet не должен быть nil после открытия")
        
        // Открытие полноэкранного представления
        navigationManager.presentFullScreenCover(TestScreen.details(id: 5))
        XCTAssertNotNil(navigationManager.activeFullScreenCover, "activeFullScreenCover не должен быть nil после открытия")
        
        // Закрытие представлений
        navigationManager.dismissSheet()
        navigationManager.dismissFullScreenCover()
        XCTAssertNil(navigationManager.activeSheet, "activeSheet должен быть nil после закрытия")
        XCTAssertNil(navigationManager.activeFullScreenCover, "activeFullScreenCover должен быть nil после закрытия")
    }
}
