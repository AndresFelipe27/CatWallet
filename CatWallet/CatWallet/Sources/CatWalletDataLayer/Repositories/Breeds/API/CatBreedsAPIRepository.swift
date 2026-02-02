//
//  CatBreedsAPIRepository.swift
//  CatWallet
//
//  Created by Andres Perdomo on 31/01/26.
//

import Foundation

final class CatBreedsAPIRepository: CatBreedsRepository {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }

    func getBreeds() async throws -> [CatBreed] {
        let endpoint = CatBreedsEndPoint()
        let response = try await networkService.request(
            endpoint,
            interceptor: CatAPIKeyInterceptor(),
            as: [CatBreedAPIResponse].self
        )
        return response.map { $0.mapToModel() }
    }
}
