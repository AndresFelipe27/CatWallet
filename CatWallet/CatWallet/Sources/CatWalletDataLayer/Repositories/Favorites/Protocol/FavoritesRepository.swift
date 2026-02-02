//
//  FavoritesRepository.swift
//  CatWallet
//
//  Created by Andres Perdomo on 01/02/26.
//

import Foundation

protocol FavoritesRepository {
    func getFavorites() -> [CatBreed]
    func isFavorite(breedId: String) -> Bool

    @discardableResult func toggleFavorite(_ breed: CatBreed) -> Bool
}
