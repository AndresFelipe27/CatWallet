//
//  ModelsTests.swift
//  CatWallet
//
//  Created by Usuario on 01/02/26.
//

import Testing
@testable import CatWallet

@Suite("Models Tests")
struct ModelsTests {
    
    // MARK: - CatBreedRowModel Tests
    
    @Test("CatBreedRowModel se inicializa correctamente")
    func testCatBreedRowModelInitialization() {
        let breed = CatBreed(
            id: "abys",
            name: "Abyssinian",
            origin: "Egypt",
            temperament: "Active, Energetic",
            description: "The Abyssinian is easy to care for.",
            lifeSpan: "14 - 15",
            weightMetric: "3 - 5",
            weightImperial: "7 - 10",
            referenceImageId: "0XYvRd7oD",
            ratings: CatBreed.Ratings(
                adaptability: 5,
                affectionLevel: 5,
                childFriendly: 3,
                dogFriendly: 4,
                energyLevel: 5,
                intelligence: 5
            )
        )
        
        let rowModel = CatBreedRowModel(breed: breed, isFavorite: true)
        
        #expect(rowModel.id == "abys")
        #expect(rowModel.breed.name == "Abyssinian")
        #expect(rowModel.isFavorite == true)
    }
    
    @Test("CatBreedRowModel es Equatable")
    func testCatBreedRowModelEquatable() {
        let breed1 = CatBreed(
            id: "1",
            name: "Breed1",
            origin: "Origin",
            temperament: "Calm",
            description: "Desc",
            lifeSpan: "10-15",
            weightMetric: "4-6",
            weightImperial: "8-13",
            referenceImageId: "img1",
            ratings: CatBreed.Ratings(
                adaptability: 5,
                affectionLevel: 5,
                childFriendly: 4,
                dogFriendly: 3,
                energyLevel: 4,
                intelligence: 5
            )
        )
        
        let rowModel1 = CatBreedRowModel(breed: breed1, isFavorite: true)
        let rowModel2 = CatBreedRowModel(breed: breed1, isFavorite: true)
        let rowModel3 = CatBreedRowModel(breed: breed1, isFavorite: false)
        
        #expect(rowModel1 == rowModel2)
        #expect(rowModel1 != rowModel3)
    }
    
    // MARK: - CatBreed Extension Tests
    
    @Test("imageURLString genera URL correcta")
    func testImageURLStringGeneration() {
        let breed = CatBreed(
            id: "test",
            name: "Test",
            origin: "Test",
            temperament: "Test",
            description: "Test",
            lifeSpan: "10",
            weightMetric: "5",
            weightImperial: "10",
            referenceImageId: "abc123",
            ratings: CatBreed.Ratings(
                adaptability: 5,
                affectionLevel: 5,
                childFriendly: 4,
                dogFriendly: 3,
                energyLevel: 4,
                intelligence: 5
            )
        )
        
        #expect(breed.imageURLString == "https://cdn2.thecatapi.com/images/abc123.jpg")
    }
    
    @Test("imageURLString retorna vacío cuando no hay referenceImageId")
    func testImageURLStringWithoutReferenceId() {
        let breed = CatBreed(
            id: "test",
            name: "Test",
            origin: "Test",
            temperament: "Test",
            description: "Test",
            lifeSpan: "10",
            weightMetric: "5",
            weightImperial: "10",
            referenceImageId: nil,
            ratings: CatBreed.Ratings(
                adaptability: 5,
                affectionLevel: 5,
                childFriendly: 4,
                dogFriendly: 3,
                energyLevel: 4,
                intelligence: 5
            )
        )
        
        #expect(breed.imageURLString == "")
    }
    
    @Test("fallbackImageURLString genera URL PNG correcta")
    func testFallbackImageURLStringGeneration() {
        let breed = CatBreed(
            id: "test",
            name: "Test",
            origin: "Test",
            temperament: "Test",
            description: "Test",
            lifeSpan: "10",
            weightMetric: "5",
            weightImperial: "10",
            referenceImageId: "xyz789",
            ratings: CatBreed.Ratings(
                adaptability: 5,
                affectionLevel: 5,
                childFriendly: 4,
                dogFriendly: 3,
                energyLevel: 4,
                intelligence: 5
            )
        )
        
        #expect(breed.fallbackImageURLString == "https://cdn2.thecatapi.com/images/xyz789.png")
    }
    
    // MARK: - CatBreed Ratings Tests
    
    @Test("CatBreed Ratings es Equatable")
    func testCatBreedRatingsEquatable() {
        let ratings1 = CatBreed.Ratings(
            adaptability: 5,
            affectionLevel: 5,
            childFriendly: 4,
            dogFriendly: 3,
            energyLevel: 4,
            intelligence: 5
        )
        
        let ratings2 = CatBreed.Ratings(
            adaptability: 5,
            affectionLevel: 5,
            childFriendly: 4,
            dogFriendly: 3,
            energyLevel: 4,
            intelligence: 5
        )
        
        let ratings3 = CatBreed.Ratings(
            adaptability: 3,
            affectionLevel: 4,
            childFriendly: 2,
            dogFriendly: 1,
            energyLevel: 2,
            intelligence: 3
        )
        
        #expect(ratings1 == ratings2)
        #expect(ratings1 != ratings3)
    }
}
