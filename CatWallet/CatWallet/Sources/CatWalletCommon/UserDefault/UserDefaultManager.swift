//
//  UserDefaultManager.swift
//  CatWallet
//
//  Created by Andres Perdomo on 31/01/26.
//

import Foundation

final class UserDefaultManager: UserDefaultManaging {
    enum UserDefaultKey {
        static let favoriteCats: String = "favorite_breeds_cats"
    }

    init() {}

    func getFavoriteBreeds() -> [CatBreed] {
        UserDefaultWrapper.get(
            key: UserDefaultKey.favoriteCats,
            as: [CatBreed].self
        ) ?? []
    }

    func setFavoriteBreeds(_ breeds: [CatBreed]) {
        UserDefaultWrapper.set(
            value: breeds,
            forKey: UserDefaultKey.favoriteCats
        )
    }

    func deleteFavoriteBreeds() {
        UserDefaultWrapper.delete(key: UserDefaultKey.favoriteCats)
    }
}
