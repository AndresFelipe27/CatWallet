//
//  CatBreedsViewModelTests.swift
//  CatWallet
//
//  Created by Usuario on 01/02/26.
//

import Foundation
import Testing
import Combine
@testable import CatWallet

@Suite("CatBreedsViewModel Tests")
@MainActor struct CatBreedsViewModelTests {
    
    // MARK: - Mocks
    
    final class MockGetCatBreedsUseCase: GetCatBreedsUseCaseType {
        var breedsToReturn: [CatBreed] = []
        var shouldThrowError = false
        var executeCallCount = 0
        
        func execute() async throws -> [CatBreed] {
            executeCallCount += 1
            if shouldThrowError {
                throw NSError(domain: "TestError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch breeds"])
            }
            return breedsToReturn
        }
    }
    
    final class MockIsFavoriteUseCase: IsFavoriteUseCaseType {
        var favoriteIds: Set<String> = []
        
        func execute(breedId: String) -> Bool {
            favoriteIds.contains(breedId)
        }
    }
    
    final class MockToggleFavoriteUseCase: ToggleFavoriteUseCaseType {
        var favoriteIds: Set<String> = []
        
        @discardableResult
        func execute(breed: CatBreed) -> Bool {
            if favoriteIds.contains(breed.id) {
                favoriteIds.remove(breed.id)
                return false
            } else {
                favoriteIds.insert(breed.id)
                return true
            }
        }
    }
    
    final class MockHasActivePaymentTokenUseCase: HasActivePaymentTokenUseCaseType {
        var hasToken = false
        
        func execute() -> Bool {
            hasToken
        }
    }
    
    final class MockTokenizePaymentMethodUseCase: TokenizePaymentMethodUseCaseType {
        var shouldSucceed = true
        var tokenToReturn = "tok_test123"
        var executeCallCount = 0
        
        func execute(paymentMethod: PaymentMethod) async throws -> String {
            executeCallCount += 1
            if !shouldSucceed {
                throw NSError(domain: "PaymentError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid card"])
            }
            return tokenToReturn
        }
    }
    
    // MARK: - Helper Methods
    
    private func createTestBreed(id: String, name: String) -> CatBreed {
        CatBreed(
            id: id,
            name: name,
            origin: "Test Origin",
            temperament: "Friendly",
            description: "Test description",
            lifeSpan: "12-15",
            weightMetric: "4-6",
            weightImperial: "8-13",
            referenceImageId: "test123",
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
    
    private func createViewModel(
        getCatBreedsUseCase: GetCatBreedsUseCaseType,
        isFavoriteUseCase: IsFavoriteUseCaseType,
        toggleFavoriteUseCase: ToggleFavoriteUseCaseType,
        hasActivePaymentTokenUseCase: HasActivePaymentTokenUseCaseType,
        tokenizePaymentMethodUseCase: TokenizePaymentMethodUseCaseType
    ) -> CatBreedsViewModel {
        let coordinator = NavigationCoordinator()
        return CatBreedsViewModel(
            coordinator: coordinator,
            getCatBreedsUseCase: getCatBreedsUseCase,
            isFavoriteUseCase: isFavoriteUseCase,
            toogleFavoriteUseCase: toggleFavoriteUseCase,
            hasActivePaymentTokenUseCase: hasActivePaymentTokenUseCase,
            tokenizePaymentMethodUseCase: tokenizePaymentMethodUseCase
        )
    }
    
    // MARK: - Tests
    
    @Test("onAppear carga las razas correctamente")
    func testOnAppearLoadsBreeds() async throws {
        let mockGetBreeds = MockGetCatBreedsUseCase()
        mockGetBreeds.breedsToReturn = [
            createTestBreed(id: "1", name: "Siamese"),
            createTestBreed(id: "2", name: "Persian")
        ]
        
        let mockIsFavorite = MockIsFavoriteUseCase()
        let mockToggleFavorite = MockToggleFavoriteUseCase()
        let mockHasToken = MockHasActivePaymentTokenUseCase()
        let mockTokenize = MockTokenizePaymentMethodUseCase()
        
        let viewModel = createViewModel(
            getCatBreedsUseCase: mockGetBreeds,
            isFavoriteUseCase: mockIsFavorite,
            toggleFavoriteUseCase: mockToggleFavorite,
            hasActivePaymentTokenUseCase: mockHasToken,
            tokenizePaymentMethodUseCase: mockTokenize
        )
        
        viewModel.onAppear()
        
        try await Task.sleep(nanoseconds: 100_000_000)
        
        #expect(viewModel.breeds.count == 2)
        #expect(viewModel.breeds[0].breed.name == "Siamese")
        #expect(viewModel.breeds[1].breed.name == "Persian")
        #expect(viewModel.isLoading == false)
        #expect(viewModel.errorMessage == nil)
    }
    
    @Test("onAppear muestra error cuando falla la carga")
    func testOnAppearShowsErrorOnFailure() async throws {
        let mockGetBreeds = MockGetCatBreedsUseCase()
        mockGetBreeds.shouldThrowError = true
        
        let mockIsFavorite = MockIsFavoriteUseCase()
        let mockToggleFavorite = MockToggleFavoriteUseCase()
        let mockHasToken = MockHasActivePaymentTokenUseCase()
        let mockTokenize = MockTokenizePaymentMethodUseCase()
        
        let viewModel = createViewModel(
            getCatBreedsUseCase: mockGetBreeds,
            isFavoriteUseCase: mockIsFavorite,
            toggleFavoriteUseCase: mockToggleFavorite,
            hasActivePaymentTokenUseCase: mockHasToken,
            tokenizePaymentMethodUseCase: mockTokenize
        )
        
        viewModel.onAppear()
        
        try await Task.sleep(nanoseconds: 100_000_000)
        
        #expect(viewModel.breeds.isEmpty)
        #expect(viewModel.isLoading == false)
        #expect(viewModel.errorMessage != nil)
    }
    
    @Test("onToggleFavorite marca y desmarca favoritos correctamente")
    func testToggleFavoriteMarksAndUnmarks() async throws {
        let mockGetBreeds = MockGetCatBreedsUseCase()
        mockGetBreeds.breedsToReturn = [createTestBreed(id: "1", name: "Siamese")]
        
        let mockIsFavorite = MockIsFavoriteUseCase()
        let mockToggleFavorite = MockToggleFavoriteUseCase()
        let mockHasToken = MockHasActivePaymentTokenUseCase()
        let mockTokenize = MockTokenizePaymentMethodUseCase()
        
        let viewModel = createViewModel(
            getCatBreedsUseCase: mockGetBreeds,
            isFavoriteUseCase: mockIsFavorite,
            toggleFavoriteUseCase: mockToggleFavorite,
            hasActivePaymentTokenUseCase: mockHasToken,
            tokenizePaymentMethodUseCase: mockTokenize
        )
        
        viewModel.onAppear()
        try await Task.sleep(nanoseconds: 100_000_000)
        
        // Marcar como favorito
        viewModel.onToggleFavorite(id: "1")
        #expect(viewModel.breeds[0].isFavorite == true)
        
        // Desmarcar
        viewModel.onToggleFavorite(id: "1")
        #expect(viewModel.breeds[0].isFavorite == false)
    }
    
    @Test("limita a 3 favoritos sin token de pago")
    func testLimitsTo3FavoritesWithoutPaymentToken() async throws {
        let mockGetBreeds = MockGetCatBreedsUseCase()
        mockGetBreeds.breedsToReturn = [
            createTestBreed(id: "1", name: "Breed1"),
            createTestBreed(id: "2", name: "Breed2"),
            createTestBreed(id: "3", name: "Breed3"),
            createTestBreed(id: "4", name: "Breed4")
        ]
        
        let mockIsFavorite = MockIsFavoriteUseCase()
        let mockToggleFavorite = MockToggleFavoriteUseCase()
        let mockHasToken = MockHasActivePaymentTokenUseCase()
        mockHasToken.hasToken = false
        let mockTokenize = MockTokenizePaymentMethodUseCase()
        
        let viewModel = createViewModel(
            getCatBreedsUseCase: mockGetBreeds,
            isFavoriteUseCase: mockIsFavorite,
            toggleFavoriteUseCase: mockToggleFavorite,
            hasActivePaymentTokenUseCase: mockHasToken,
            tokenizePaymentMethodUseCase: mockTokenize
        )
        
        viewModel.onAppear()
        try await Task.sleep(nanoseconds: 100_000_000)
        
        // Marcar 3 favoritos
        viewModel.onToggleFavorite(id: "1")
        viewModel.onToggleFavorite(id: "2")
        viewModel.onToggleFavorite(id: "3")
        
        #expect(viewModel.breeds[0].isFavorite == true)
        #expect(viewModel.breeds[1].isFavorite == true)
        #expect(viewModel.breeds[2].isFavorite == true)
        
        // Intentar marcar el cuarto debería abrir el sheet de vinculación
        viewModel.onToggleFavorite(id: "4")
        
        #expect(viewModel.isLinkCardSheetPresented == true)
        #expect(viewModel.breeds[3].isFavorite == false) // No se marcó
    }
    
    @Test("permite favoritos ilimitados con token de pago activo")
    func testAllowsUnlimitedFavoritesWithPaymentToken() async throws {
        let mockGetBreeds = MockGetCatBreedsUseCase()
        mockGetBreeds.breedsToReturn = [
            createTestBreed(id: "1", name: "Breed1"),
            createTestBreed(id: "2", name: "Breed2"),
            createTestBreed(id: "3", name: "Breed3"),
            createTestBreed(id: "4", name: "Breed4")
        ]
        
        let mockIsFavorite = MockIsFavoriteUseCase()
        let mockToggleFavorite = MockToggleFavoriteUseCase()
        let mockHasToken = MockHasActivePaymentTokenUseCase()
        mockHasToken.hasToken = true // Usuario tiene token
        let mockTokenize = MockTokenizePaymentMethodUseCase()
        
        let viewModel = createViewModel(
            getCatBreedsUseCase: mockGetBreeds,
            isFavoriteUseCase: mockIsFavorite,
            toggleFavoriteUseCase: mockToggleFavorite,
            hasActivePaymentTokenUseCase: mockHasToken,
            tokenizePaymentMethodUseCase: mockTokenize
        )
        
        viewModel.onAppear()
        try await Task.sleep(nanoseconds: 100_000_000)
        
        // Marcar 4 favoritos sin restricción
        viewModel.onToggleFavorite(id: "1")
        viewModel.onToggleFavorite(id: "2")
        viewModel.onToggleFavorite(id: "3")
        viewModel.onToggleFavorite(id: "4")
        
        #expect(viewModel.breeds[0].isFavorite == true)
        #expect(viewModel.breeds[1].isFavorite == true)
        #expect(viewModel.breeds[2].isFavorite == true)
        #expect(viewModel.breeds[3].isFavorite == true)
        #expect(viewModel.isLinkCardSheetPresented == false)
    }
    
    @Test("vincula tarjeta exitosamente y desbloquea favoritos")
    func testLinksCardSuccessfullyAndUnlocksFavorites() async throws {
        let mockGetBreeds = MockGetCatBreedsUseCase()
        mockGetBreeds.breedsToReturn = [
            createTestBreed(id: "1", name: "Breed1"),
            createTestBreed(id: "2", name: "Breed2"),
            createTestBreed(id: "3", name: "Breed3"),
            createTestBreed(id: "4", name: "Breed4")
        ]
        
        let mockIsFavorite = MockIsFavoriteUseCase()
        let mockToggleFavorite = MockToggleFavoriteUseCase()
        let mockHasToken = MockHasActivePaymentTokenUseCase()
        mockHasToken.hasToken = false
        let mockTokenize = MockTokenizePaymentMethodUseCase()
        mockTokenize.shouldSucceed = true
        
        let viewModel = createViewModel(
            getCatBreedsUseCase: mockGetBreeds,
            isFavoriteUseCase: mockIsFavorite,
            toggleFavoriteUseCase: mockToggleFavorite,
            hasActivePaymentTokenUseCase: mockHasToken,
            tokenizePaymentMethodUseCase: mockTokenize
        )
        
        viewModel.onAppear()
        try await Task.sleep(nanoseconds: 100_000_000)
        
        // Marcar 3 favoritos
        viewModel.onToggleFavorite(id: "1")
        viewModel.onToggleFavorite(id: "2")
        viewModel.onToggleFavorite(id: "3")
        
        // Intentar el cuarto abre el sheet
        viewModel.onToggleFavorite(id: "4")
        #expect(viewModel.isLinkCardSheetPresented == true)
        
        // Enviar tarjeta válida
        let testCard = PaymentMethod(
            cardholderName: "Test User",
            cardNumber: "4242424242424242",
            expMonth: 12,
            expYear: 2026,
            cvc: "123"
        )
        
        viewModel.onSubmitTestCard(testCard)
        try await Task.sleep(nanoseconds: 500_000_000)
        
        #expect(viewModel.isLinkingCard == false)
        #expect(viewModel.isLinkCardSheetPresented == false)
        #expect(viewModel.hasActivePaymentToken == true)
        #expect(viewModel.breeds[3].isFavorite == true) // Se marcó el pendiente
    }
    
    @Test("muestra error al fallar vinculación de tarjeta")
    func testShowsErrorOnCardLinkingFailure() async throws {
        let mockGetBreeds = MockGetCatBreedsUseCase()
        mockGetBreeds.breedsToReturn = [createTestBreed(id: "1", name: "Breed1")]
        
        let mockIsFavorite = MockIsFavoriteUseCase()
        let mockToggleFavorite = MockToggleFavoriteUseCase()
        let mockHasToken = MockHasActivePaymentTokenUseCase()
        let mockTokenize = MockTokenizePaymentMethodUseCase()
        mockTokenize.shouldSucceed = false
        
        let viewModel = createViewModel(
            getCatBreedsUseCase: mockGetBreeds,
            isFavoriteUseCase: mockIsFavorite,
            toggleFavoriteUseCase: mockToggleFavorite,
            hasActivePaymentTokenUseCase: mockHasToken,
            tokenizePaymentMethodUseCase: mockTokenize
        )
        
        let testCard = PaymentMethod(
            cardholderName: "Invalid",
            cardNumber: "0000000000000000",
            expMonth: 1,
            expYear: 2020,
            cvc: "0"
        )
        
        viewModel.onSubmitTestCard(testCard)
        try await Task.sleep(nanoseconds: 100_000_000)
        
        #expect(viewModel.isLinkingCard == false)
        #expect(viewModel.linkCardErrorMessage != nil)
    }
    
    @Test("onRequestCloseLinkCard limpia el estado del sheet")
    func testOnRequestCloseLinkCardClearsState() async throws {
        let mockGetBreeds = MockGetCatBreedsUseCase()
        mockGetBreeds.breedsToReturn = [
            createTestBreed(id: "1", name: "Breed1"),
            createTestBreed(id: "2", name: "Breed2"),
            createTestBreed(id: "3", name: "Breed3"),
            createTestBreed(id: "4", name: "Breed4")
        ]
        
        let mockIsFavorite = MockIsFavoriteUseCase()
        let mockToggleFavorite = MockToggleFavoriteUseCase()
        let mockHasToken = MockHasActivePaymentTokenUseCase()
        let mockTokenize = MockTokenizePaymentMethodUseCase()
        
        let viewModel = createViewModel(
            getCatBreedsUseCase: mockGetBreeds,
            isFavoriteUseCase: mockIsFavorite,
            toggleFavoriteUseCase: mockToggleFavorite,
            hasActivePaymentTokenUseCase: mockHasToken,
            tokenizePaymentMethodUseCase: mockTokenize
        )
        
        viewModel.onAppear()
        try await Task.sleep(nanoseconds: 100_000_000)
        
        // Marcar 3 y abrir sheet
        viewModel.onToggleFavorite(id: "1")
        viewModel.onToggleFavorite(id: "2")
        viewModel.onToggleFavorite(id: "3")
        viewModel.onToggleFavorite(id: "4")
        
        #expect(viewModel.isLinkCardSheetPresented == true)
        
        // Cerrar el sheet
        viewModel.onRequestCloseLinkCard()
        
        #expect(viewModel.isLinkCardSheetPresented == false)
        #expect(viewModel.linkCardErrorMessage == nil)
    }
}
