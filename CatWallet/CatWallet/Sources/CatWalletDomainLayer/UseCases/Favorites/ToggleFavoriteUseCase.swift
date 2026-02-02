//
//  ToggleFavoriteUseCase.swift
//  CatWallet
//
//  Created by Andres Perdomo on 01/02/26.
//

import Foundation

protocol ToggleFavoriteUseCaseType {
    @discardableResult func execute(breed: CatBreed) -> Bool
}

final class ToggleFavoriteUseCase: ToggleFavoriteUseCaseType {
    private let repository: FavoritesRepository

    init(repository: FavoritesRepository = FavoritesRepositoryImpl()) {
        self.repository = repository
    }

    @discardableResult func execute(breed: CatBreed) -> Bool {
        repository.toggleFavorite(breed)
    }
}
