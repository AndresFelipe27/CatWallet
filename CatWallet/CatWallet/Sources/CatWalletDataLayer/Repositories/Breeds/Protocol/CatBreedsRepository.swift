//
//  CatBreedsRepository.swift
//  CatWallet
//
//  Created by Andres Perdomo on 31/01/26.
//

import Foundation

protocol CatBreedsRepository {
    func getBreeds() async throws -> [CatBreed]
}
