//
//  IsFavoriteUseCase.swift
//  CatWallet
//
//  Created by Andres Perdomo on 01/02/26.
//

import Foundation

protocol IsFavoriteUseCaseType {
    func execute(breedId: String) -> Bool
}

final class IsFavoriteUseCase: IsFavoriteUseCaseType {
    private let repository: FavoritesRepository

    init(repository: FavoritesRepository = FavoritesRepositoryImpl()) {
        self.repository = repository
    }

    func execute(breedId: String) -> Bool {
        repository.isFavorite(breedId: breedId)
    }
}
