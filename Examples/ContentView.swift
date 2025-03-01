// ContentView.swift - Демонстрация возможностей фреймворка NavigationKit
import SwiftUI
import NavigationKit

struct ContentView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    
    var body: some View {
        // 1️⃣ NavigationContainer - объединяет стек навигации с менеджером
        NavigationContainer(
            navigationManager: navigationManager,
            rootView: { MainContent() },
            destinationBuilder: { (screen: AppScreen) in screen.body }
        )
        // 2️⃣ Поддержка модальных окон разных типов
        .withNavigationModals(
            navigationManager: navigationManager,
            sheetContent: { (screen: ModalScreen) in screen.body },
            fullScreenCoverContent: { (screen: ModalScreen) in screen.body }
        )
    }
}

// 3️⃣ Главный экран с демонстрацией разных функций навигации
struct MainContent: View {
    @EnvironmentObject var navigationManager: NavigationManager
    
    var body: some View {
        VStack(spacing: 20) {
            Text("NavigationKit Demo")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 30)
            
            // 4️⃣ Кнопки для демонстрации возможностей NavigationKit
            VStack(spacing: 16) {
                // Стандартная push-навигация с параметрами
                NavigationDemoButton(
                    title: "Go to Details",
                    color: .blue
                ) {
                    navigationManager.navigate(to: AppScreen.details(id: 42))
                }
                
                // Навигация с передачей строковых параметров
                NavigationDemoButton(
                    title: "Go to Profile",
                    color: .indigo
                ) {
                    navigationManager.navigate(to: AppScreen.profile(name: "John Doe"))
                }
                
                // Показ модального sheet-окна
                NavigationDemoButton(
                    title: "Show Settings Sheet",
                    color: .green
                ) {
                    navigationManager.presentSheet(ModalScreen.settings)
                }
                
                // Показ полноэкранного модального окна
                NavigationDemoButton(
                    title: "Show Full Screen",
                    color: .orange
                ) {
                    navigationManager.presentFullScreenCover(ModalScreen.settings)
                }
            }
            .padding(.horizontal)
        }
        .padding()
        .navigationTitle("NavigationKit")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Компонент для создания единообразных кнопок
struct NavigationDemoButton: View {
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .foregroundColor(.white)
                .background(color)
                .cornerRadius(10)
                .shadow(color: color.opacity(0.3), radius: 3, x: 0, y: 2)
        }
    }
}

// 5️⃣ Типобезопасное описание экранов навигации через enum
enum AppScreen: Screen, Hashable {
    case main
    case details(id: Int)
    case profile(name: String)
    
    // Автоматическое создание представления для каждого кейса
    var body: some View {
        switch self {
        case .main:
            Text("Main Screen")
        case .details(let value):
            DetailsView(id: value)
        case .profile(let name):
            ProfileView(name: name)
        }
    }
}

// 6️⃣ Отдельная иерархия для модальных окон
enum ModalScreen: Screen, Hashable, Identifiable {
    case settings
    case info(message: String)
    
    // Реализация Identifiable для модальных экранов
    var id: String {
        switch self {
        case .settings:
            return "settings"
        case .info(let message):
            return "info-\(message)"
        }
    }
    
    var body: some View {
        switch self {
        case .settings:
            SettingsView()
        case .info(let message):
            InfoView(message: message)
        }
    }
}

// 7️⃣ Детальный экран с навигацией назад и вызовом модального окна
struct DetailsView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    let id: Int
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Details Screen \(id)")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 20)
            
            // Одинаковый стиль кнопок с главным экраном
            VStack(spacing: 16) {
                // Кнопка возврата назад
                NavigationDemoButton(
                    title: "Go Back",
                    color: .blue
                ) {
                    navigationManager.navigateBack()
                }
                
                // Модальное окно с передачей параметра
                NavigationDemoButton(
                    title: "Show Info Modal",
                    color: .green
                ) {
                    navigationManager.presentSheet(ModalScreen.info(message: "Details info for ID: \(id)"))
                }
            }
            .padding(.horizontal)
        }
        .padding()
        .navigationTitle("Details #\(id)")
    }
}

// 8️⃣ Экран профиля с возвратом к корню навигации
struct ProfileView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    let name: String
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome, \(name)!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 20)
            
            // Возврат к корневому экрану
            NavigationDemoButton(
                title: "Go to Root",
                color: .red
            ) {
                navigationManager.navigateToRoot()
            }
            .padding(.horizontal)
        }
        .padding()
        .navigationTitle("Profile")
    }
}

// 9️⃣ Модальный экран настроек с закрытием
struct SettingsView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Settings")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)
                
                // Закрытие текущего модального окна
                NavigationDemoButton(
                    title: "Close",
                    color: .red
                ) {
                    navigationManager.dismissSheet()
                    navigationManager.dismissFullScreenCover()
                }
                .padding(.horizontal)
            }
            .padding()
            .navigationTitle("Settings")
        }
    }
}

// 🔟 Информационное модальное окно с параметрами
struct InfoView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    let message: String
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Information")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 10)
            
            // Отображение переданного параметра
            Text(message)
                .font(.body)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                .padding(.bottom, 10)
            
            // Закрытие модального окна
            NavigationDemoButton(
                title: "Dismiss",
                color: .blue
            ) {
                navigationManager.dismissSheet()
            }
            .padding(.horizontal)
        }
        .padding()
    }
}
