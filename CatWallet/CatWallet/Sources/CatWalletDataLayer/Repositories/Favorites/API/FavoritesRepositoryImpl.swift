//
//  FavoritesRepositoryImpl.swift
//  CatWallet
//
//  Created by Andres Perdomo on 01/02/26.
//

import Foundation

final class FavoritesRepositoryImpl: FavoritesRepository {
    private let userDefaultManager: UserDefaultManaging

    init(userDefaultManager: UserDefaultManaging = UserDefaultManager()) {
        self.userDefaultManager = userDefaultManager
    }

    func getFavorites() -> [CatBreed] {
        userDefaultManager.getFavoriteBreeds()
    }

    func isFavorite(breedId: String) -> Bool {
        userDefaultManager.getFavoriteBreeds().contains(where: { $0.id == breedId })
    }

    @discardableResult func toggleFavorite(_ breed: CatBreed) -> Bool {
        var favorites = userDefaultManager.getFavoriteBreeds()

        if let index = favorites.firstIndex(where: { $0.id == breed.id }) {
            favorites.remove(at: index)
            userDefaultManager.setFavoriteBreeds(favorites)
            return false
        } else {
            favorites.append(breed)
            userDefaultManager.setFavoriteBreeds(favorites)
            return true
        }
    }
}
