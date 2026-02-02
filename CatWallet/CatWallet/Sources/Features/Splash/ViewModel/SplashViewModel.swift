//
//  SplashViewModel.swift
//  CatWallet
//
//  Created by Andres Perdomo on 31/01/26.
//

import Combine
import SwiftUI

final class SplashViewModel: SplashViewModelProtocol {
    @Published private(set) var isAnimating: Bool = true

    private let coordinator: NavigationCoordinator
    private var cancellables = Set<AnyCancellable>()

    init(coordinator: NavigationCoordinator) {
        self.coordinator = coordinator
    }

    func onAppear() {
        startDelayAndNavigate()
    }

    private func startDelayAndNavigate() {
        Just(())
            .delay(for: .seconds(.splashSeconds), scheduler: RunLoop.main)
            .sink { [weak self] in
                self?.navigateToBreedsList()
            }
            .store(in: &cancellables)
    }

    private func navigateToBreedsList() {
        Task { @MainActor in
            coordinator.push(
                CatBreedsView(
                    viewModel: CatBreedsViewModel(coordinator: self.coordinator)
                ),
                tag: .catBreeds
            )
        }
    }
}

private extension Double {
    static let splashSeconds: Double = 1.2
}
