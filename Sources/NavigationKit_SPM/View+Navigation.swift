//
//  View+Navigation.swift
//  NavigationKit
//
//  Created by Kaider on 01.03.2025.
//

import SwiftUI

public extension View {
    /// Добавляет NavigationManager как EnvironmentObject к представлению
    func withNavigationManager(_ manager: NavigationManager) -> some View {
        self.environmentObject(manager)
    }
    
    /// Настраивает представление для использования с NavigationStack и NavigationManager
    func withNavigationContainer<S: Hashable & Screen>(
        navigationManager: NavigationManager,
        @ViewBuilder rootView: @escaping () -> Self,
        @ViewBuilder destinationBuilder: @escaping (S) -> S.Body
    ) -> some View {
        NavigationContainer(
            navigationManager: navigationManager,
            rootView: rootView,
            destinationBuilder: destinationBuilder
        )
    }
    
    /// Применяет модификаторы для модальных представлений с NavigationManager
    func withNavigationModals<SheetScreen: Hashable & Screen & Identifiable, FullScreenCover: Hashable & Screen & Identifiable>(
        navigationManager: NavigationManager,
        @ViewBuilder sheetContent: @escaping (SheetScreen) -> SheetScreen.Body,
        @ViewBuilder fullScreenCoverContent: @escaping (FullScreenCover) -> FullScreenCover.Body
    ) -> some View {
        self
            .sheet(item: sheetBinding(navigationManager)) { screen in
                sheetContent(screen)
                    .environmentObject(navigationManager)
            }
            .fullScreenCover(item: fullScreenBinding(navigationManager)) { screen in
                fullScreenCoverContent(screen)
                    .environmentObject(navigationManager)
            }
            .modifier(ConfirmationDialogViewModifier(
                navigationManager: navigationManager
            ))
    }
    
    // Вспомогательные функции для создания привязок
    private func sheetBinding<T: Identifiable>(_ navigationManager: NavigationManager) -> Binding<T?> {
        Binding<T?>(
            get: {
                // Пытаемся преобразовать activeSheet к типу T
                if let sheet = navigationManager.activeSheet as? T {
                    return sheet
                }
                return nil
            },
            set: { newValue in
                // При установке nil, очищаем activeSheet
                if newValue == nil {
                    navigationManager.activeSheet = nil
                }
            }
        )
    }
    
    private func fullScreenBinding<T: Identifiable>(_ navigationManager: NavigationManager) -> Binding<T?> {
        Binding<T?>(
            get: {
                // Пытаемся преобразовать activeFullScreenCover к типу T
                if let cover = navigationManager.activeFullScreenCover as? T {
                    return cover
                }
                return nil
            },
            set: { newValue in
                // При установке nil, очищаем activeFullScreenCover
                if newValue == nil {
                    navigationManager.activeFullScreenCover = nil
                }
            }
        )
    }
}

/// Модификатор для отображения диалога подтверждения.
private struct ConfirmationDialogViewModifier: ViewModifier {
    let navigationManager: NavigationManager
    
    func body(content view: Content) -> some View {
        // Явно создаем Binding из менеджера навигации
        let isPresentedBinding = Binding<Bool>(
            get: { navigationManager.isConfirmationDialogPresented },
            set: { navigationManager.isConfirmationDialogPresented = $0 }
        )
        
        return view.confirmationDialog(
            navigationManager.confirmationDialogData?.title ?? "",
            isPresented: isPresentedBinding,
            presenting: navigationManager.confirmationDialogData
        ) { data in
            ForEach(data.buttons) { button in
                switch button.style {
                case .default:
                    Button(button.title) { button.action() }
                case .cancel:
                    Button(button.title, role: .cancel) { button.action() }
                case .destructive:
                    Button(button.title, role: .destructive) { button.action() }
                }
            }
        } message: { data in
            if let message = data.message {
                Text(message)
            }
        }
    }
}
