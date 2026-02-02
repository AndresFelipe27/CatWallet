//
//  CatBreedsEndPoint.swift
//  CatWallet
//
//  Created by Andres Perdomo on 31/01/26.
//

import Foundation

struct CatBreedsEndPoint: APIEndpoint {
    var baseURL: URL { CatAPIConfig.baseURL }

    var path: String { "breeds" }

    var method: HTTPMethod { .get }

    var headers: [String: String]? {
        [:]
    }

    var parameters: [String: Any]? {
        [:]
    }

    var queryParameters: [String: String]? {
        [:]
    }
}
