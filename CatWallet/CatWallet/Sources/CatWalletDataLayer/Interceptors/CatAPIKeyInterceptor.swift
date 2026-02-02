//
//  CatAPIKeyInterceptor.swift
//  CatWallet
//
//  Created by Andres Perdomo on 31/01/26.
//

import Foundation

public final class CatAPIKeyInterceptor: RequestInterceptor {
    private let repository: CatBreedsRepository

    init(repository: CatBreedsRepository = CatBreedsAPIRepository()) {
        self.repository = repository
    }

    public func retry(_ request: URLRequest, for response: URLResponse?, with error: any Error) async throws -> Bool {
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 401 else {
            return false
        }
        return true
    }

    public func adapt(_ request: URLRequest) async throws -> URLRequest {
        var request = request
        request.setValue(CatAPIConfig.apiKey, forHTTPHeaderField: "x-api-key")
        return request
    }
}
