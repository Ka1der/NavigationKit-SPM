//
//  NavigationManagerTests.swift
//  NavigationKitTests
//
//  Created by Kaider on 01.03.2025.
//

import XCTest
import SwiftUI
@testable import NavigationKit

@MainActor
final class NavigationManagerTests: XCTestCase {
    
    // Тестовая структура маршрутов для использования в тестах
    enum TestScreen: Screen, Hashable {
        case main
        case details(id: Int)
        case settings
        
        var body: some View {
            switch self {
            case .main:
                Text("Main Screen")
            case .details(let id):
                Text("Details Screen \(id)")
            case .settings:
                Text("Settings Screen")
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
    
    // MARK: - Stack Navigation Tests
    
    @MainActor func testNavigateToScreen() async {
        // Проверка начального состояния
        XCTAssertTrue(navigationManager.path.isEmpty, "Начальный путь навигации должен быть пустым")
        
        // Переход на экран
        navigationManager.navigate(to: TestScreen.details(id: 1))
        
        // Проверка корректности перехода
        XCTAssertEqual(navigationManager.path.count, 1, "После перехода путь навигации должен содержать 1 элемент")
    }
    
    @MainActor func testMultipleNavigations() async {
        // Несколько переходов
        navigationManager.navigate(to: TestScreen.details(id: 1))
        navigationManager.navigate(to: TestScreen.settings)
        
        // Проверка пути навигации
        XCTAssertEqual(navigationManager.path.count, 2, "После двух переходов путь навигации должен содержать 2 элемента")
    }
    
    @MainActor func testNavigateBack() async {
        // Подготовка пути
        navigationManager.navigate(to: TestScreen.details(id: 1))
        navigationManager.navigate(to: TestScreen.settings)
        XCTAssertEqual(navigationManager.path.count, 2, "Путь навигации должен содержать 2 элемента")
        
        // Проверка возврата на предыдущий экран
        navigationManager.navigateBack()
        XCTAssertEqual(navigationManager.path.count, 1, "После возврата путь навигации должен содержать 1 элемент")
        
        // Проверка возврата к корневому экрану
        navigationManager.navigateBack()
        XCTAssertTrue(navigationManager.path.isEmpty, "После возврата к корневому экрану путь навигации должен быть пустым")
    }
    
    @MainActor func testNavigateToRoot() async {
        // Подготовка пути с несколькими экранами
        navigationManager.navigate(to: TestScreen.details(id: 1))
        navigationManager.navigate(to: TestScreen.settings)
        navigationManager.navigate(to: TestScreen.details(id: 2))
        XCTAssertEqual(navigationManager.path.count, 3, "Путь навигации должен содержать 3 элемента")
        
        // Проверка возврата к корневому экрану
        navigationManager.navigateToRoot()
        XCTAssertTrue(navigationManager.path.isEmpty, "После возврата к корню путь навигации должен быть пустым")
    }
    
    // MARK: - Modal Navigation Tests
    
    @MainActor func testPresentSheet() async {
        // Проверка начального состояния
        XCTAssertNil(navigationManager.activeSheet, "Начальное значение activeSheet должно быть nil")
        
        // Открытие модального окна
        navigationManager.presentSheet(TestScreen.settings)
        
        // Проверка состояния
        XCTAssertNotNil(navigationManager.activeSheet, "activeSheet не должен быть nil после открытия")
    }
    
    @MainActor func testDismissSheet() async {
        // Подготовка модального окна
        navigationManager.presentSheet(TestScreen.settings)
        XCTAssertNotNil(navigationManager.activeSheet, "activeSheet не должен быть nil после открытия")
        
        // Закрытие модального окна
        navigationManager.dismissSheet()
        XCTAssertNil(navigationManager.activeSheet, "activeSheet должен быть nil после закрытия")
    }
    
    @MainActor func testPresentFullScreenCover() async {
        // Проверка начального состояния
        XCTAssertNil(navigationManager.activeFullScreenCover, "Начальное значение activeFullScreenCover должно быть nil")
        
        // Открытие полноэкранного представления
        navigationManager.presentFullScreenCover(TestScreen.details(id: 5))
        
        // Проверка состояния
        XCTAssertNotNil(navigationManager.activeFullScreenCover, "activeFullScreenCover не должен быть nil после открытия")
    }
    
    @MainActor func testDismissFullScreenCover() async {
        // Подготовка полноэкранного представления
        navigationManager.presentFullScreenCover(TestScreen.details(id: 5))
        XCTAssertNotNil(navigationManager.activeFullScreenCover, "activeFullScreenCover не должен быть nil после открытия")
        
        // Закрытие полноэкранного представления
        navigationManager.dismissFullScreenCover()
        XCTAssertNil(navigationManager.activeFullScreenCover, "activeFullScreenCover должен быть nil после закрытия")
    }
    
    // MARK: - Confirmation Dialog Tests
    
    @MainActor func testPresentConfirmationDialog() async {
        // Проверка начального состояния
        XCTAssertFalse(navigationManager.isConfirmationDialogPresented, "Начальное значение isConfirmationDialogPresented должно быть false")
        XCTAssertNil(navigationManager.confirmationDialogData, "Начальное значение confirmationDialogData должно быть nil")
        
        // Создание данных диалога
        let dialogData = ConfirmationDialogData(
            title: "Подтверждение",
            message: "Вы уверены?",
            buttons: [
                DialogButton(title: "Да", action: {}),
                DialogButton(title: "Отмена", style: .cancel, action: {})
            ]
        )
        
        // Показ диалога
        navigationManager.presentConfirmationDialog(dialogData)
        
        // Проверка состояния
        XCTAssertTrue(navigationManager.isConfirmationDialogPresented, "isConfirmationDialogPresented должно быть true после показа")
        XCTAssertNotNil(navigationManager.confirmationDialogData, "confirmationDialogData не должен быть nil после показа")
        XCTAssertEqual(navigationManager.confirmationDialogData?.title, "Подтверждение", "Заголовок диалога должен соответствовать")
        XCTAssertEqual(navigationManager.confirmationDialogData?.message, "Вы уверены?", "Сообщение диалога должно соответствовать")
        XCTAssertEqual(navigationManager.confirmationDialogData?.buttons.count, 2, "Диалог должен содержать 2 кнопки")
    }
    
    @MainActor func testDismissConfirmationDialog() async {
        // Подготовка диалога
        let dialogData = ConfirmationDialogData(
            title: "Подтверждение",
            message: "Вы уверены?",
            buttons: [
                DialogButton(title: "Да", action: {}),
                DialogButton(title: "Отмена", style: .cancel, action: {})
            ]
        )
        
        navigationManager.presentConfirmationDialog(dialogData)
        XCTAssertTrue(navigationManager.isConfirmationDialogPresented, "isConfirmationDialogPresented должно быть true после показа")
        
        // Закрытие диалога
        navigationManager.dismissConfirmationDialog()
        XCTAssertFalse(navigationManager.isConfirmationDialogPresented, "isConfirmationDialogPresented должно быть false после закрытия")
        XCTAssertNil(navigationManager.confirmationDialogData, "confirmationDialogData должен быть nil после закрытия")
    }
    
    // MARK: - Combined Navigation Tests
    
    @MainActor func testCombinedNavigationOperations() async {
        // Проверка начального состояния
        XCTAssertTrue(navigationManager.path.isEmpty, "Начальный путь навигации должен быть пустым")
        XCTAssertNil(navigationManager.activeSheet, "Начальное значение activeSheet должно быть nil")
        
        // Выполняем несколько операций навигации
        navigationManager.navigate(to: TestScreen.details(id: 1))
        navigationManager.navigate(to: TestScreen.settings)
        navigationManager.presentSheet(TestScreen.details(id: 10))
        
        // Проверяем состояние после операций
        XCTAssertEqual(navigationManager.path.count, 2, "Путь навигации должен содержать 2 элемента")
        XCTAssertNotNil(navigationManager.activeSheet, "activeSheet не должен быть nil после открытия")
        
        // Закрываем модальное окно
        navigationManager.dismissSheet()
        XCTAssertNil(navigationManager.activeSheet, "activeSheet должен быть nil после закрытия")
        
        // Проверяем, что путь навигации не изменился после закрытия модального окна
        XCTAssertEqual(navigationManager.path.count, 2, "Путь навигации должен остаться неизменным")
        
        // Возвращаемся к корневому экрану
        navigationManager.navigateToRoot()
        XCTAssertTrue(navigationManager.path.isEmpty, "После возврата к корню путь навигации должен быть пустым")
    }
}
