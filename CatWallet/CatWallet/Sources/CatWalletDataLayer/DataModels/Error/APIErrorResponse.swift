//
//  APIErrorResponse.swift
//  CatWallet
//
//  Created by Andres Perdomo on 30/01/26.
//

import Foundation

public struct APIErrorResponse: Codable, Error {
    public let code: String
    public let message: String

    enum CodingKeys: String, CodingKey {
        case code
        case message
    }
}
