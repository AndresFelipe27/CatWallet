//
//  KeychainManager.swift
//  CatWallet
//
//  Created by Andres Perdomo on 01/02/26.
//

import Foundation

public final class KeychainManager: KeychainManaging {
    enum KeychainKey {
        static let paymentToken: String = "catwallet_payment_token"
    }

    public init() {}

    public func setPaymentToken(_ token: String) {
        KeychainWrapper.set(value: token, forKey: KeychainKey.paymentToken)
    }

    public func getPaymentToken() -> String? {
        KeychainWrapper.get(key: KeychainKey.paymentToken)
    }

    public func deletePaymentToken() {
        KeychainWrapper.delete(key: KeychainKey.paymentToken)
    }
}
