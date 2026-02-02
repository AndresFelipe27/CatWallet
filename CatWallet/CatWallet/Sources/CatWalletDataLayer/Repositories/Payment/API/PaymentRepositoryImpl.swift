//
//  PaymentRepositoryImpl.swift
//  CatWallet
//
//  Created by Andres Perdomo on 01/02/26.
//

import Foundation

final class PaymentRepositoryImpl: PaymentRepository {
    private let keychainManager: KeychainManaging

    init(keychainManager: KeychainManaging = KeychainManager()) {
        self.keychainManager = keychainManager
    }

    func getActiveToken() -> String? {
        keychainManager.getPaymentToken()
    }

    func saveActiveToken(_ token: String) {
        keychainManager.setPaymentToken(token)
    }

    func deleteActiveToken() {
        keychainManager.deletePaymentToken()
    }

    func tokenize(paymentMethod: PaymentMethod) async throws -> String {
        try await Task.sleep(nanoseconds: 450_000_000)

        guard Self.isValidTestCard(paymentMethod) else {
            throw PaymentError.invalidCard
        }

        let token = "tok_" + UUID().uuidString.replacingOccurrences(of: "-", with: "")
        saveActiveToken(token)
        return token
    }

    private static func isValidTestCard(_ paymentMethod: PaymentMethod) -> Bool {
        // Reglas simples de demo: tarjeta de prueba
        // 4242 4242 4242 4242, exp >= current year, CVC 3+
        let digits = paymentMethod.cardNumber.filter(\.isNumber)
        guard digits == "4242424242424242" else { return false }
        guard (1...12).contains(paymentMethod.expMonth) else { return false }
        guard paymentMethod.expYear >= Calendar.current.component(.year, from: Date()) else { return false }
        guard paymentMethod.cvc.count >= 3 else { return false }
        guard !paymentMethod.cardholderName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return false }
        return true
    }
}
