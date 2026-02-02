//
//  KeychainManaging.swift
//  CatWallet
//
//  Created by Andres Perdomo on 01/02/26.
//

import Foundation

public protocol KeychainManaging: AnyObject {
    func setPaymentToken(_ token: String)
    func getPaymentToken() -> String?
    func deletePaymentToken()
}
