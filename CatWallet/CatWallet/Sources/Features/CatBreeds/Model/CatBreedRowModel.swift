//
//  CatBreedRowModel.swift
//  CatWallet
//
//  Created by Andres Perdomo on 01/02/26.
//

import Foundation

struct CatBreedRowModel: Identifiable, Equatable {
    let id: String
    let breed: CatBreed
    var isFavorite: Bool

    init(breed: CatBreed, isFavorite: Bool) {
        self.id = breed.id
        self.breed = breed
        self.isFavorite = isFavorite
    }
}
