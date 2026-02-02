//
//  CatBreedsViewModelProtocol.swift
//  CatWallet
//
//  Created by Andres Perdomo on 31/01/26.
//

import Combine
import Foundation

protocol CatBreedsViewModelProtocol: ObservableObject {
    var isLoading: Bool { get }
    var breeds: [CatBreedRowModel] { get }
    var errorMessage: String? { get }

    var isLinkCardSheetPresented: Bool { get }
    var isLinkingCard: Bool { get }
    var linkCardErrorMessage: String? { get }
    var hasActivePaymentToken: Bool { get }

    func onAppear()
    func onTapRetry()
    func onToggleFavorite(id: String)

    func onRequestCloseLinkCard()
    func onSubmitTestCard(_ card: PaymentMethod)
}
