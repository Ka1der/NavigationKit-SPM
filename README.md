
# NavigationKit

NavigationKit — современный фреймворк для управления навигацией в SwiftUI-приложениях. Он предоставляет удобный и гибкий способ управления переходами между экранами, модальными окнами и диалогами.

Этот фреймворк основан на подходе, описанном в статье на Хабре: [Современная навигация в SwiftUI-приложении](https://habr.com/ru/articles/830392/).

## Возможности

- **Стековая навигация** — управление стеком экранов с помощью `NavigationStack`
- **Модальные представления** — управление модальными окнами (`sheet`, `fullScreenCover`)
- **Централизованное управление** — единый менеджер для всех типов навигации
- **Типобезопасность** — полная поддержка типобезопасности Swift
- **Поддержка SwiftUI** — современный подход на основе SwiftUI

## Требования

- iOS 16.0+
- Swift 6.0+

## Установка

Добавьте NavigationKit как зависимость через Swift Package Manager.

## Использование

### Настройка менеджера навигации

```swift
import NavigationKit
import SwiftUI

@main
struct MyApp: App {
    // Создаем менеджер навигации
    @StateObject private var navigationManager = NavigationKit.createNavigationManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .withNavigationManager(navigationManager)
        }
    }
}
```

### Определение экранов

```swift
enum AppScreen: Screen, Hashable {
    case main
    case details(id: Int)
    case settings
    
    var body: some View {
        switch self {
        case .main:
            MainView()
        case .details(let id):
            DetailsView(id: id)
        case .settings:
            SettingsView()
        }
    }
}
```

### Использование контейнера навигации

```swift
struct ContentView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    
    var body: some View {
        NavigationContainer(
            navigationManager: navigationManager,
            rootView: { MainView() },
            destinationBuilder: { (screen: AppScreen) in screen.body }
        )
        .withNavigationModals(
            navigationManager: navigationManager,
            sheetContent: { (screen: AppScreen) in screen.body },
            fullScreenCoverContent: { (screen: AppScreen) in screen.body }
        )
    }
}
```

### Переход между экранами

```swift
struct MainView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    
    var body: some View {
        VStack {
            Button("Перейти к деталям") {
                navigationManager.navigate(to: AppScreen.details(id: 1))
            }
            
            Button("Открыть настройки в модальном окне") {
                navigationManager.presentSheet(AppScreen.settings)
            }
            
            Button("Показать диалог подтверждения") {
                let dialogData = ConfirmationDialogData(
                    title: "Подтверждение",
                    message: "Вы уверены?",
                    buttons: [
                        DialogButton(title: "Да", action: { /* действие при подтверждении */ }),
                        DialogButton(title: "Отмена", style: .cancel, action: {})
                    ]
                )
                navigationManager.presentConfirmationDialog(dialogData)
            }
        }
    }
}
```

### Возврат назад

```swift
struct DetailsView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    let id: Int
    
    var body: some View {
        VStack {
            Text("Экран деталей #\(id)")
            
            Button("Вернуться назад") {
                navigationManager.navigateBack()
            }
            
            Button("Вернуться на главный экран") {
                navigationManager.navigateToRoot()
            }
        }
    }
}
```

## Пример использования

В директории `Examples/NavigationKitDemo` содержится полноценный пример использования фреймворка NavigationKit. Пример демонстрирует:

- Настройку `NavigationManager` в приложении
- Стековую навигацию с параметрами
- Модальные окна (`sheet` и `fullScreenCover`)
- Навигацию назад и к корневому экрану
- Типобезопасность при работе с экранами

Чтобы запустить пример, создайте новый проект iOS-приложения и добавьте в него файлы из директории `Examples`:

- `NavigationKitDemoApp.swift`
- `ContentView.swift`

Этот код содержит подробные комментарии, которые помогут разобраться с основными концепциями и возможностями NavigationKit.

## Основные компоненты

### `NavigationManager`
Центральный класс для управления всеми аспектами навигации:

- Стек экранов (`push`/`pop`)
- Модальные окна (`sheet`/`fullScreenCover`)
- Диалоги подтверждения

### `NavigationContainer`
Контейнер, объединяющий `NavigationStack` с менеджером навигации для обеспечения типобезопасной навигации по стеку.

### `Screen`
Протокол для определения экранов приложения с поддержкой SwiftUI-представлений.

## Лицензия

NavigationKit доступен под лицензией MIT. 

## Автор

NavigationKit разработан **Kaider** в 2025 году.
