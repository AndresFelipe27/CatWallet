//
//  CatBreedAPIResponse.swift
//  CatWallet
//
//  Created by Andres Perdomo on 31/01/26.
//

import Foundation

struct CatBreedAPIResponse: Decodable {
    let weight: WeightAPIResponse?
    let id: String
    let name: String
    let breedGroup: String?
    let cfaURL: String?
    let vetstreetURL: String?
    let vcahospitalsURL: String?
    let temperament: String?
    let origin: String?
    let countryCodes: String?
    let countryCode: String?
    let description: String?
    let lifeSpan: String?
    let indoor: Int?
    let lap: Int?
    let altNames: String?
    let adaptability: Int?
    let affectionLevel: Int?
    let childFriendly: Int?
    let dogFriendly: Int?
    let energyLevel: Int?
    let grooming: Int?
    let healthIssues: Int?
    let intelligence: Int?
    let sheddingLevel: Int?
    let socialNeeds: Int?
    let strangerFriendly: Int?
    let vocalisation: Int?
    let experimental: Int?
    let hairless: Int?
    let natural: Int?
    let rare: Int?
    let rex: Int?
    let suppressedTail: Int?
    let shortLegs: Int?
    let wikipediaURL: String?
    let hypoallergenic: Int?
    let referenceImageId: String?

    enum CodingKeys: String, CodingKey {
        case weight
        case id
        case name
        case breedGroup = "breed_group"
        case cfaURL = "cfa_url"
        case vetstreetURL = "vetstreet_url"
        case vcahospitalsURL = "vcahospitals_url"
        case temperament
        case origin
        case countryCodes = "country_codes"
        case countryCode = "country_code"
        case description
        case lifeSpan = "life_span"
        case indoor
        case lap
        case altNames = "alt_names"
        case adaptability = "adaptability"
        case affectionLevel = "affection_level"
        case childFriendly = "child_friendly"
        case dogFriendly = "dog_friendly"
        case energyLevel = "energy_level"
        case grooming = "grooming"
        case healthIssues = "health_issues"
        case intelligence = "intelligence"
        case sheddingLevel = "shedding_level"
        case socialNeeds = "social_needs"
        case strangerFriendly = "stranger_friendly"
        case vocalisation
        case experimental
        case hairless
        case natural
        case rare
        case rex
        case suppressedTail = "suppressed_tail"
        case shortLegs = "short_legs"
        case wikipediaURL = "wikipedia_url"
        case hypoallergenic
        case referenceImageId = "reference_image_id"
    }
}

struct WeightAPIResponse: Decodable {
    let imperial: String?
    let metric: String?
}

extension CatBreedAPIResponse {
    func mapToModel() -> CatBreed {
        CatBreed(
            id: id,
            name: name,
            origin: origin.orEmpty,
            temperament: temperament.orEmpty,
            description: description.orEmpty,
            lifeSpan: lifeSpan.orEmpty,
            weightMetric: weight?.metric.orEmpty ?? "",
            weightImperial: weight?.imperial.orEmpty ?? "",
            referenceImageId: referenceImageId,
            ratings: .init(
                adaptability: adaptability ?? 0,
                affectionLevel: affectionLevel ?? 0,
                childFriendly: childFriendly ?? 0,
                dogFriendly: dogFriendly ?? 0,
                energyLevel: energyLevel ?? 0,
                intelligence: intelligence ?? 0
            )
        )
    }
}

private extension Optional where Wrapped == String {
    var orEmpty: String { self ?? "" }
}
