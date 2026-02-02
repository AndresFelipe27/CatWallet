//
//  UserDefaultManaging.swift
//  CatWallet
//
//  Created by Andres Perdomo on 31/01/26.
//

import Foundation

protocol UserDefaultManaging: AnyObject {
    func getFavoriteBreeds() -> [CatBreed]
    func setFavoriteBreeds(_ breeds: [CatBreed])
    func deleteFavoriteBreeds()
}
