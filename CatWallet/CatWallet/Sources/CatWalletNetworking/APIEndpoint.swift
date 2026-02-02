//
//  APIEndpoint.swift
//  CatWallet
//
//  Created by Andres Perdomo on 30/01/26.
//

import Foundation

public enum APIContentType: String {
    case json = "application/json"
    case formURLEncoded = "application/x-www-form-urlencoded"
}

public protocol APIEndpoint {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var parameters: [String: Any]? { get }
    var contentType: APIContentType { get }
    var urlRequest: URLRequest { get }
    var queryParameters: [String: String]? { get }
}

public extension APIEndpoint {
    var contentType: APIContentType { .json }

    var urlRequest: URLRequest {
        var request: URLRequest

        if method == .get, let params = parameters {
            var urlComponents = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false)
            if let queryParams = queryParameters, !queryParams.isEmpty {
                urlComponents?.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
            }
            let additionalQueryItems = params.map { key, value in
                URLQueryItem(name: key, value: String(describing: value))
            }
            urlComponents?.queryItems?.append(contentsOf: additionalQueryItems)
            let finalURL = urlComponents?.url ?? baseURL.appendingPathComponent(path)
            request = URLRequest(url: finalURL)
        } else {
            request = URLRequest(url: baseURL.appendingPathComponent(path))
            if let parameters = parameters {
                switch contentType {
                case .json:
                    request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
                case .formURLEncoded:
                    let bodyString = parameters.map {
                        "\($0)=\("\($1)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
                    }
                    .joined(separator: "&")
                    request.httpBody = bodyString.data(using: .utf8)
                }
            }
        }

        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers

        return request
    }
}
