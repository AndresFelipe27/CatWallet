//
//  PaymentMethod.swift
//  CatWallet
//
//  Created by Andres Perdomo on 01/02/26.
//

import Foundation

struct PaymentMethod: Equatable {
    let cardholderName: String
    let cardNumber: String
    let expMonth: Int
    let expYear: Int
    let cvc: String
}
