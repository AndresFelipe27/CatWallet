//
//  RequestInterceptor.swift
//  CatWallet
//
//  Created by Andres Perdomo on 30/01/26.
//

import Foundation

public protocol RequestInterceptor {
    func adapt(_ urlRequest: URLRequest) async throws -> URLRequest
    func retry(_ request: URLRequest, for response: URLResponse?, with error: Error) async throws -> Bool
}
