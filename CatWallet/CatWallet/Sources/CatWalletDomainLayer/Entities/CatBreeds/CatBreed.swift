//
//  CatBreed.swift
//  CatWallet
//
//  Created by Andres Perdomo on 31/01/26.
//

import Foundation

struct CatBreed: Codable, Identifiable, Equatable {
    let id: String
    let name: String
    let origin: String
    let temperament: String
    let description: String
    let lifeSpan: String
    let weightMetric: String
    let weightImperial: String
    let referenceImageId: String?
    let ratings: Ratings

    struct Ratings: Codable, Equatable {
        let adaptability: Int
        let affectionLevel: Int
        let childFriendly: Int
        let dogFriendly: Int
        let energyLevel: Int
        let intelligence: Int
    }
}

extension CatBreed {
    var imageURLString: String {
        guard let id = referenceImageId, !id.isEmpty else { return "" }
        return "https://cdn2.thecatapi.com/images/\(id).jpg"
    }

    var fallbackImageURLString: String {
        guard let id = referenceImageId, !id.isEmpty else { return "" }
        return "https://cdn2.thecatapi.com/images/\(id).png"
    }
}
