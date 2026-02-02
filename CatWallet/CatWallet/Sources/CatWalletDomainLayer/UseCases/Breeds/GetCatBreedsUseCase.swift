//
//  GetCatBreedsUseCase.swift
//  CatWallet
//
//  Created by Andres Perdomo on 31/01/26.
//

import Foundation

protocol GetCatBreedsUseCaseType {
    func execute() async throws -> [CatBreed]
}

final class GetCatBreedsUseCase: GetCatBreedsUseCaseType {
    private let repository: CatBreedsRepository

    init(repository: CatBreedsRepository = CatBreedsAPIRepository()) {
        self.repository = repository
    }

    func execute() async throws -> [CatBreed] {
        try await repository.getBreeds()
    }
}
