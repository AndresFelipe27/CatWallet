//
//  TokenizePaymentMethodUseCase.swift
//  CatWallet
//
//  Created by Andres Perdomo on 01/02/26.
//

import Foundation

protocol TokenizePaymentMethodUseCaseType {
    func execute(paymentMethod: PaymentMethod) async throws -> String
}

final class TokenizePaymentMethodUseCase: TokenizePaymentMethodUseCaseType {
    private let repository: PaymentRepository

    init(repository: PaymentRepository = PaymentRepositoryImpl()) {
        self.repository = repository
    }

    func execute(paymentMethod: PaymentMethod) async throws -> String {
        try await repository.tokenize(paymentMethod: paymentMethod)
    }
}
