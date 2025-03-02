//
//  NavigationManager.swift
//  NavigationKit
//
//  Created by Kaider on 01.03.2025.
//

import SwiftUI
import Combine

/// Основной класс для управления навигацией
@MainActor
public final class NavigationManager: @preconcurrency NavigationStateProtocol {
    /// Путь навигации
    @Published public var path = NavigationPath()
    
    /// Активный экран в модальном представлении (sheet)
    @Published public var activeSheet: AnyHashable?
    
    /// Активный экран в полноэкранном модальном представлении
    @Published public var activeFullScreenCover: AnyHashable?
    
    /// Флаг для отображения диалога подтверждения
    @Published public var isConfirmationDialogPresented: Bool = false
    
    /// Данные для диалога подтверждения
    @Published public var confirmationDialogData: ConfirmationDialogData?
    
    /// История навигации для отладки
    private var navigationHistory: [NavigationAction] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    public init() {
        setupSubscribers()
    }
    
    private func setupSubscribers() {
        // Подписки на изменения состояния для логирования и других действий
        $path
            .sink { [weak self] _ in
                self?.logNavigationAction(.pathChanged)
            }
            .store(in: &cancellables)
        
        $activeSheet
            .sink { [weak self] screen in
                if screen != nil {
                    self?.logNavigationAction(.sheetPresented)
                } else {
                    self?.logNavigationAction(.sheetDismissed)
                }
            }
            .store(in: &cancellables)
        
        $activeFullScreenCover
            .sink { [weak self] screen in
                if screen != nil {
                    self?.logNavigationAction(.fullScreenCoverPresented)
                } else {
                    self?.logNavigationAction(.fullScreenCoverDismissed)
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Navigation Methods
    
    /// Переход на новый экран путем добавления в стек
    public func navigate<S: Hashable>(to screen: S) {
        logNavigationAction(.push(screen))
        path.append(screen)
    }
    
    /// Возврат на один экран назад
    public func navigateBack() {
        guard !path.isEmpty else { return }
        logNavigationAction(.pop)
        path.removeLast()
    }
    
    /// Возврат к корневому экрану
    public func navigateToRoot() {
        guard !path.isEmpty else { return }
        logNavigationAction(.popToRoot)
        path.removeLast(path.count)
    }
    
    /// Показ модального экрана
    public func presentSheet<S: Hashable>(_ screen: S) {
        logNavigationAction(.presentSheet(screen))
        activeSheet = screen
    }
    
    /// Скрытие модального экрана
    public func dismissSheet() {
        logNavigationAction(.dismissSheet)
        activeSheet = nil
    }
    
    /// Показ полноэкранного модального представления
    public func presentFullScreenCover<S: Hashable>(_ screen: S) {
        logNavigationAction(.presentFullScreenCover(screen))
        activeFullScreenCover = screen
    }
    
    /// Скрытие полноэкранного модального представления
    public func dismissFullScreenCover() {
        logNavigationAction(.dismissFullScreenCover)
        activeFullScreenCover = nil
    }
    
    /// Показ диалога подтверждения
    public func presentConfirmationDialog(_ data: ConfirmationDialogData) {
        confirmationDialogData = data
        isConfirmationDialogPresented = true
    }
    
    /// Скрытие диалога подтверждения
    public func dismissConfirmationDialog() {
        isConfirmationDialogPresented = false
        confirmationDialogData = nil
    }
    
    // MARK: - Helper Methods
    
    /// Логирование действий навигации
    private func logNavigationAction(_ action: NavigationAction) {
        navigationHistory.append(action)
    }
}

/// Типы действий навигации для логирования
enum NavigationAction: CustomStringConvertible {
    case push(AnyHashable)
    case pop
    case popToRoot
    case presentSheet(AnyHashable)
    case dismissSheet
    case presentFullScreenCover(AnyHashable)
    case dismissFullScreenCover
    case pathChanged
    case sheetPresented
    case sheetDismissed
    case fullScreenCoverPresented
    case fullScreenCoverDismissed
    
    var description: String {
        switch self {
        case .push(let screen):
            return "Push screen: \(screen)"
        case .pop:
            return "Pop screen"
        case .popToRoot:
            return "Pop to root"
        case .presentSheet(let screen):
            return "Present sheet: \(screen)"
        case .dismissSheet:
            return "Dismiss sheet"
        case .presentFullScreenCover(let screen):
            return "Present full screen cover: \(screen)"
        case .dismissFullScreenCover:
            return "Dismiss full screen cover"
        case .pathChanged:
            return "Path changed"
        case .sheetPresented:
            return "Sheet presented"
        case .sheetDismissed:
            return "Sheet dismissed"
        case .fullScreenCoverPresented:
            return "Full screen cover presented"
        case .fullScreenCoverDismissed:
            return "Full screen cover dismissed"
        }
    }
}
