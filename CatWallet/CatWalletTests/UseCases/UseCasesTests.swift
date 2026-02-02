//
//  UseCasesTests.swift
//  CatWallet
//
//  Created by Usuario on 01/02/26.
//

import Foundation
import Testing
@testable import CatWallet

@Suite("Use Cases Tests")
@MainActor struct UseCasesTests {
    
    // MARK: - Mock Repositories
    
    final class MockCatBreedsRepository: CatBreedsRepository {
        var breedsToReturn: [CatBreed] = []
        var shouldThrowError = false
        
        func getBreeds() async throws -> [CatBreed] {
            if shouldThrowError {
                throw NSError(domain: "TestError", code: -1)
            }
            return breedsToReturn
        }
    }
    
    final class MockFavoritesRepository: FavoritesRepository {
        var favorites: [CatBreed] = []
        
        func getFavorites() -> [CatBreed] {
            favorites
        }
        
        func isFavorite(breedId: String) -> Bool {
            favorites.contains(where: { $0.id == breedId })
        }
        
        @discardableResult
        func toggleFavorite(_ breed: CatBreed) -> Bool {
            if let index = favorites.firstIndex(where: { $0.id == breed.id }) {
                favorites.remove(at: index)
                return false
            } else {
                favorites.append(breed)
                return true
            }
        }
    }
    
    final class MockPaymentRepository: PaymentRepository {
        var activeToken: String?
        var shouldFailTokenization = false
        
        func getActiveToken() -> String? {
            activeToken
        }
        
        func saveActiveToken(_ token: String) {
            activeToken = token
        }
        
        func deleteActiveToken() {
            activeToken = nil
        }
        
        func tokenize(paymentMethod: PaymentMethod) async throws -> String {
            if shouldFailTokenization {
                throw PaymentError.invalidCard
            }
            let token = "tok_test123"
            saveActiveToken(token)
            return token
        }
    }
    
    // MARK: - Helper
    
    private func createTestBreed(id: String, name: String) -> CatBreed {
        CatBreed(
            id: id,
            name: name,
            origin: "Test",
            temperament: "Friendly",
            description: "Description",
            lifeSpan: "10-15",
            weightMetric: "4-6",
            weightImperial: "8-13",
            referenceImageId: "img123",
            ratings: CatBreed.Ratings(
                adaptability: 5,
                affectionLevel: 5,
                childFriendly: 4,
                dogFriendly: 3,
                energyLevel: 4,
                intelligence: 5
            )
        )
    }
    
    // MARK: - GetCatBreedsUseCase Tests
    
    @Test("GetCatBreedsUseCase retorna razas exitosamente")
    func testGetCatBreedsUseCaseReturnsBreeds() async throws {
        let mockRepo = MockCatBreedsRepository()
        mockRepo.breedsToReturn = [
            createTestBreed(id: "1", name: "Siamese"),
            createTestBreed(id: "2", name: "Persian")
        ]
        
        let useCase = GetCatBreedsUseCase(repository: mockRepo)
        let breeds = try await useCase.execute()
        
        #expect(breeds.count == 2)
        #expect(breeds[0].name == "Siamese")
        #expect(breeds[1].name == "Persian")
    }
    
    @Test("GetCatBreedsUseCase propaga errores")
    func testGetCatBreedsUseCaseThrowsError() async throws {
        let mockRepo = MockCatBreedsRepository()
        mockRepo.shouldThrowError = true
        
        let useCase = GetCatBreedsUseCase(repository: mockRepo)
        
        await #expect(throws: Error.self) {
            try await useCase.execute()
        }
    }
    
    // MARK: - IsFavoriteUseCase Tests
    
    @Test("IsFavoriteUseCase retorna true cuando la raza es favorita")
    func testIsFavoriteUseCaseReturnsTrueForFavorite() {
        let mockRepo = MockFavoritesRepository()
        mockRepo.favorites = [createTestBreed(id: "1", name: "Siamese")]
        
        let useCase = IsFavoriteUseCase(repository: mockRepo)
        let isFavorite = useCase.execute(breedId: "1")
        
        #expect(isFavorite == true)
    }
    
    @Test("IsFavoriteUseCase retorna false cuando la raza no es favorita")
    func testIsFavoriteUseCaseReturnsFalseForNonFavorite() {
        let mockRepo = MockFavoritesRepository()
        mockRepo.favorites = []
        
        let useCase = IsFavoriteUseCase(repository: mockRepo)
        let isFavorite = useCase.execute(breedId: "1")
        
        #expect(isFavorite == false)
    }
    
    // MARK: - ToggleFavoriteUseCase Tests
    
    @Test("ToggleFavoriteUseCase agrega favorito correctamente")
    func testToggleFavoriteUseCaseAddsFavorite() {
        let mockRepo = MockFavoritesRepository()
        let breed = createTestBreed(id: "1", name: "Siamese")
        
        let useCase = ToggleFavoriteUseCase(repository: mockRepo)
        let result = useCase.execute(breed: breed)
        
        #expect(result == true)
        #expect(mockRepo.favorites.count == 1)
        #expect(mockRepo.favorites[0].id == "1")
    }
    
    @Test("ToggleFavoriteUseCase elimina favorito correctamente")
    func testToggleFavoriteUseCaseRemovesFavorite() {
        let mockRepo = MockFavoritesRepository()
        let breed = createTestBreed(id: "1", name: "Siamese")
        mockRepo.favorites = [breed]
        
        let useCase = ToggleFavoriteUseCase(repository: mockRepo)
        let result = useCase.execute(breed: breed)
        
        #expect(result == false)
        #expect(mockRepo.favorites.isEmpty)
    }
    
    // MARK: - HasActivePaymentTokenUseCase Tests
    
    @Test("HasActivePaymentTokenUseCase retorna true cuando hay token")
    func testHasActivePaymentTokenUseCaseReturnsTrueWithToken() {
        let mockRepo = MockPaymentRepository()
        mockRepo.activeToken = "tok_123"
        
        let useCase = HasActivePaymentTokenUseCase(repository: mockRepo)
        let hasToken = useCase.execute()
        
        #expect(hasToken == true)
    }
    
    @Test("HasActivePaymentTokenUseCase retorna false sin token")
    func testHasActivePaymentTokenUseCaseReturnsFalseWithoutToken() {
        let mockRepo = MockPaymentRepository()
        mockRepo.activeToken = nil
        
        let useCase = HasActivePaymentTokenUseCase(repository: mockRepo)
        let hasToken = useCase.execute()
        
        #expect(hasToken == false)
    }
    
    // MARK: - TokenizePaymentMethodUseCase Tests
    
    @Test("TokenizePaymentMethodUseCase tokeniza exitosamente")
    func testTokenizePaymentMethodUseCaseSucceeds() async throws {
        let mockRepo = MockPaymentRepository()
        let useCase = TokenizePaymentMethodUseCase(repository: mockRepo)
        
        let paymentMethod = PaymentMethod(
            cardholderName: "Test User",
            cardNumber: "4242424242424242",
            expMonth: 12,
            expYear: 2026,
            cvc: "123"
        )
        
        let token = try await useCase.execute(paymentMethod: paymentMethod)
        
        #expect(token == "tok_test123")
        #expect(mockRepo.activeToken == "tok_test123")
    }
    
    @Test("TokenizePaymentMethodUseCase falla con tarjeta inválida")
    func testTokenizePaymentMethodUseCaseFailsWithInvalidCard() async throws {
        let mockRepo = MockPaymentRepository()
        mockRepo.shouldFailTokenization = true
        
        let useCase = TokenizePaymentMethodUseCase(repository: mockRepo)
        
        let paymentMethod = PaymentMethod(
            cardholderName: "Invalid",
            cardNumber: "0000000000000000",
            expMonth: 1,
            expYear: 2020,
            cvc: "000"
        )
        
        await #expect(throws: PaymentError.self) {
            try await useCase.execute(paymentMethod: paymentMethod)
        }
    }
}
