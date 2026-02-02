//
//  NetworkService.swift
//  CatWallet
//
//  Created by Andres Perdomo on 30/01/26.
//

import Foundation

public protocol NetworkServiceProtocol {
    func request<T: Decodable>(
        _ endpoint: any APIEndpoint,
        interceptor: (any RequestInterceptor)?,
        as type: T.Type,
        retryCount: Int,
        maxRetries: Int
    ) async throws -> T
}

extension NetworkServiceProtocol {
    func request<T: Decodable>(
        _ endpoint: any APIEndpoint,
        interceptor: (any RequestInterceptor)? = nil,
        as type: T.Type,
        retryCount: Int = 0,
        maxRetries: Int = 2
    ) async throws -> T {
        try await request(
            endpoint,
            interceptor: interceptor,
            as: type,
            retryCount: retryCount,
            maxRetries: maxRetries
        )
    }
}

public struct NetworkService: NetworkServiceProtocol {
    public static let shared = NetworkService()

    private init() {}

    public func request<T: Decodable>(
        _ endpoint: APIEndpoint,
        interceptor: RequestInterceptor? = nil,
        as type: T.Type,
        retryCount: Int = 0,
        maxRetries: Int = 2
    ) async throws -> T {
        var urlRequest = endpoint.urlRequest
        if let interceptor = interceptor {
            urlRequest = try await interceptor.adapt(urlRequest)
        }

        urlRequest.setValue(endpoint.contentType.rawValue, forHTTPHeaderField: "Content-Type")

        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }

            if !(200...299).contains(httpResponse.statusCode) {
                if let apiError = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {
                    if retryCount < maxRetries,
                       let interceptor = interceptor,
                       try await interceptor.retry(urlRequest, for: response, with: apiError) {
                        return try await request(
                            endpoint,
                            interceptor: interceptor,
                            as: type,
                            retryCount: retryCount + 1
                        )
                    }

                    throw apiError
                }

                if retryCount < maxRetries,
                   let interceptor = interceptor,
                   try await interceptor.retry(urlRequest, for: response, with: URLError(.badServerResponse)) {
                    return try await request(endpoint, interceptor: interceptor, as: type, retryCount: retryCount + 1)
                }

                throw URLError(.badServerResponse)
            }

            if data.isEmpty {
                if let emptyResponse = APIEmptyResponse() as? T {
                    return emptyResponse
                } else {
                    throw URLError(.cannotDecodeContentData)
                }
            }

            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            if retryCount < maxRetries,
               let interceptor = interceptor,
               try await interceptor.retry(urlRequest, for: nil, with: error) {
                return try await request(endpoint, interceptor: interceptor, as: type, retryCount: retryCount + 1)
            }

            throw error
        }
    }
}
