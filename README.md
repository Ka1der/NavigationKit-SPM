
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

### 1. Создайте менеджер навигации

```swift
@StateObject private var navigationManager = NavigationKit.createNavigationManager()
```

### 2. Добавьте менеджер в ваше приложение

```swift
ContentView()
    .withNavigationManager(navigationManager)
```

### 3. Опишите ваши экраны

```swift
enum AppScreen: Screen, Hashable {
    case main
    case details(id: Int)
    
    var body: some View {
        switch self {
        case .main: MainView()
        case .details(let id): DetailsView(id: id)
        }
    }
}
```

### 4. Настройте корневой экран

```swift
NavigationContainer(
    navigationManager: navigationManager,
    rootView: { MainView() },
    destinationBuilder: { (screen: AppScreen) in screen.body }
)
```

### 5. Переходите между экранами

```swift
@EnvironmentObject var navigationManager: NavigationManager

// Переход на новый экран:
Button("Открыть детали") {
    navigationManager.path.append(AppScreen.details(id: 42))
}

// Возврат назад:
Button("Назад") {
    navigationManager.path.removeLast()
}

// Возврат в начало:
Button("На главную") {
    navigationManager.path.removeAll()
}
```

### Простой пример

#### Главный экран

```swift
struct MainView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    
    var body: some View {
        VStack {
            Text("Главный экран")
            
            Button("Открыть детали") {
                navigationManager.path.append(AppScreen.details(id: 123))
            }
        }
    }
}
```

#### Экран с деталями

```swift
struct DetailsView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    let id: Int
    
    var body: some View {
        VStack {
            Text("Детали №\(id)")
            
            Button("Назад") {
                navigationManager.path.removeLast()
            }
        }
    }
}
```
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
