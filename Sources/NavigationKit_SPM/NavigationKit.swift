//
//  NavigationKit.swift
//  NavigationKit
//
//  Created by Kaider on 01.03.2025.
//

import SwiftUI

/// Основная точка входа для фреймворка NavigationKit
public struct NavigationKit {
    /// Создает новый менеджер навигации
    @MainActor public static func createNavigationManager() -> NavigationManager {
        return NavigationManager()
    }
    
    /// Версия фреймворка
    public static let version = "1.0.0"
    
    /// Информация о фреймворке
    public static let info = """
        NavigationKit \(version)
        A modern SwiftUI navigation framework.
        """
}
