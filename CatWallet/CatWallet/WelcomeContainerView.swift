//
//  WelcomeContainerView.swift
//  CatWallet
//
//  Created by Andres Perdomo on 31/01/26.
//

import SwiftUI

struct WelcomeContainerView: View {
    @ObservedObject private var navigationCoordinator: NavigationCoordinator

    init(coordinator: NavigationCoordinator) {
        self.navigationCoordinator = coordinator
    }

    var body: some View {
        NavigationStack(path: $navigationCoordinator.path) {
            SplashView(viewModel: SplashViewModel(coordinator: navigationCoordinator))
                .navigationDestination(for: NavigationItem.self) { item in
                    item.view
                }
        }
    }
}
