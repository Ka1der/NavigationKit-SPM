//
//  NavigationContainer.swift
//  NavigationKit
//
//  Created by Kaider on 01.03.2025.
//

import SwiftUI

/// Контейнер для навигации, объединяющий NavigationStack и NavigationManager
public struct NavigationContainer<Root: View, S: Hashable & Screen>: View {
    @ObservedObject private var navigationManager: NavigationManager
    private let rootView: () -> Root
    private let destinationBuilder: (S) -> S.Body
    
    public init(
        navigationManager: NavigationManager,
        @ViewBuilder rootView: @escaping () -> Root,
        @ViewBuilder destinationBuilder: @escaping (S) -> S.Body
    ) {
        self.navigationManager = navigationManager
        self.rootView = rootView
        self.destinationBuilder = destinationBuilder
    }
    
    public var body: some View {
        NavigationStack(path: $navigationManager.path) {
            rootView()
                .navigationDestination(for: S.self) { screen in
                    destinationBuilder(screen)
                }
        }
        .environmentObject(navigationManager)
    }
}
