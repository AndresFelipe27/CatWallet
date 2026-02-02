//
//  PaymentRepository.swift
//  CatWallet
//
//  Created by Andres Perdomo on 01/02/26.
//

import Foundation

protocol PaymentRepository {
    func getActiveToken() -> String?
    func saveActiveToken(_ token: String)
    func deleteActiveToken()

    func tokenize(paymentMethod: PaymentMethod) async throws -> String
}
