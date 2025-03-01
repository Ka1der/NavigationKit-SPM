//
//  NavigationProtocols.swift
//  NavigationKit
//
//  Created by Kaider on 01.03.2025.
//

import SwiftUI

/// Протокол для объектов, которые могут быть использованы в качестве экранов в навигации
public protocol Screen: Hashable {
    associatedtype Body: View
    @ViewBuilder var body: Self.Body { get }
    
    /// Уникальный идентификатор экрана
    var id: String { get }
}

/// Расширение по умолчанию для идентификатора Screen, основанного на типе и хэше
public extension Screen {
    var id: String {
        let typeName = String(describing: Self.self)
        let hashValue = self.hashValue
        return "\(typeName)-\(hashValue)"
    }
}

/// Протокол для состояния навигации
public protocol NavigationStateProtocol: ObservableObject {
    /// Путь навигации
    var path: NavigationPath { get set }
    
    /// Активный экран в модальном представлении
    var activeSheet: AnyHashable? { get set }
    
    /// Активный экран в полноэкранном модальном представлении
    var activeFullScreenCover: AnyHashable? { get set }
    
    /// Флаг для отображения диалога подтверждения
    var isConfirmationDialogPresented: Bool { get set }
    
    /// Данные для диалога подтверждения
    var confirmationDialogData: ConfirmationDialogData? { get set }
}

/// Данные для диалога подтверждения
public struct ConfirmationDialogData: Identifiable {
    public var id = UUID()
    public var title: String
    public var message: String?
    public var buttons: [DialogButton]
    
    public init(title: String, message: String? = nil, buttons: [DialogButton] = []) {
        self.title = title
        self.message = message
        self.buttons = buttons
    }
}

/// Кнопка для диалога
public struct DialogButton: Identifiable {
    public enum ButtonStyle {
        case `default`
        case cancel
        case destructive
    }
    
    public var id = UUID()
    public var title: String
    public var style: ButtonStyle
    public var action: () -> Void
    
    public init(title: String, style: ButtonStyle = .default, action: @escaping () -> Void) {
        self.title = title
        self.style = style
        self.action = action
    }
}
