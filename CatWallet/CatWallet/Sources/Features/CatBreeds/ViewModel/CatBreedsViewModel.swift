//
//  CatBreedsViewModel.swift
//  CatWallet
//
//  Created by Andres Perdomo on 31/01/26.
//

import Combine
import Foundation

final class CatBreedsViewModel: CatBreedsViewModelProtocol {
    private let coordinator: NavigationCoordinator
    private let getCatBreedsUseCase: GetCatBreedsUseCaseType
    private let isFavoriteUseCase: IsFavoriteUseCaseType
    private let toggleFavoriteUseCase: ToggleFavoriteUseCaseType

    private let hasActivePaymentTokenUseCase: HasActivePaymentTokenUseCaseType
    private let tokenizePaymentMethodUseCase: TokenizePaymentMethodUseCaseType

    @Published private(set) var isLoading: Bool = false
    @Published private(set) var breeds: [CatBreedRowModel] = []
    @Published private(set) var errorMessage: String?

    @Published private(set) var isLinkCardSheetPresented: Bool = false
    @Published private(set) var isLinkingCard: Bool = false
    @Published private(set) var linkCardErrorMessage: String?
    @Published private(set) var hasActivePaymentToken: Bool = false

    private var pendingToggleBreedId: String?

    init(
        coordinator: NavigationCoordinator,
        getCatBreedsUseCase: GetCatBreedsUseCaseType = GetCatBreedsUseCase(),
        isFavoriteUseCase: IsFavoriteUseCaseType = IsFavoriteUseCase(),
        toogleFavoriteUseCase: ToggleFavoriteUseCaseType = ToggleFavoriteUseCase(),
        hasActivePaymentTokenUseCase: HasActivePaymentTokenUseCaseType = HasActivePaymentTokenUseCase(),
        tokenizePaymentMethodUseCase: TokenizePaymentMethodUseCaseType = TokenizePaymentMethodUseCase()
    ) {
        self.coordinator = coordinator
        self.getCatBreedsUseCase = getCatBreedsUseCase
        self.isFavoriteUseCase = isFavoriteUseCase
        self.toggleFavoriteUseCase = toogleFavoriteUseCase
        self.hasActivePaymentTokenUseCase = hasActivePaymentTokenUseCase
        self.tokenizePaymentMethodUseCase = tokenizePaymentMethodUseCase
    }

    func onAppear() {
        hasActivePaymentToken = hasActivePaymentTokenUseCase.execute()
        guard breeds.isEmpty else { return }
        fetchBreeds()
    }

    func onTapRetry() {
        fetchBreeds()
    }

    func onToggleFavorite(id: String) {
        guard let index = breeds.firstIndex(where: { $0.id == id }) else { return }
        let current = breeds[index]

        if current.isFavorite {
            let isNowFavorite = toggleFavoriteUseCase.execute(breed: current.breed)
            breeds[index].isFavorite = isNowFavorite
            return
        }

        let favoritesCount = breeds.filter(\.isFavorite).count
        let isLimitReached = favoritesCount >= 3 && !hasActivePaymentToken

        guard !isLimitReached else {
            pendingToggleBreedId = id
            presentLinkCardSheet()
            return
        }

        let isNowFavorite = toggleFavoriteUseCase.execute(breed: current.breed)
        breeds[index].isFavorite = isNowFavorite
    }

    func onRequestCloseLinkCard() {
        isLinkCardSheetPresented = false
        linkCardErrorMessage = nil
        pendingToggleBreedId = nil
    }

    func onSubmitTestCard(_ card: PaymentMethod) {
        linkCardErrorMessage = nil
        isLinkingCard = true

        Task {
            do {
                _ = try await tokenizePaymentMethodUseCase.execute(paymentMethod: card)
                hasActivePaymentToken = true
                isLinkingCard = false
                isLinkCardSheetPresented = false

                if let id = pendingToggleBreedId {
                    pendingToggleBreedId = nil
                    onToggleFavorite(id: id)
                }
            } catch {
                isLinkingCard = false
                linkCardErrorMessage = error.localizedDescription
            }
        }
    }

    private func presentLinkCardSheet() {
        linkCardErrorMessage = nil
        isLinkCardSheetPresented = true
    }

    private func fetchBreeds() {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let response = try await getCatBreedsUseCase.execute()
                self.breeds = response.map { breed in
                    CatBreedRowModel(
                        breed: breed,
                        isFavorite: isFavoriteUseCase.execute(breedId: breed.id)
                    )
                }
                self.isLoading = false
            } catch {
                self.isLoading = false
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
