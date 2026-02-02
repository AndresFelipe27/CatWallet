//
//  HasActivePaymentTokenUseCase.swift
//  CatWallet
//
//  Created by Andres Perdomo on 01/02/26.
//

import Foundation

protocol HasActivePaymentTokenUseCaseType {
    func execute() -> Bool
}

final class HasActivePaymentTokenUseCase: HasActivePaymentTokenUseCaseType {
    private let repository: PaymentRepository

    init(repository: PaymentRepository = PaymentRepositoryImpl()) {
        self.repository = repository
    }

    func execute() -> Bool {
        repository.getActiveToken() != nil
    }
}
