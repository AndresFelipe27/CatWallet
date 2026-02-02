//
//  PaymentError.swift
//  CatWallet
//
//  Created by Andres Perdomo on 01/02/26.
//

import Foundation

enum PaymentError: LocalizedError, Equatable {
    case invalidCard
    case tokenizationFailed

    var errorDescription: String? {
        switch self {
        case .invalidCard:
            return "Tarjeta inválida. Usa una tarjeta de prueba."
        case .tokenizationFailed:
            return "No fue posible tokenizar la tarjeta. Intenta nuevamente."
        }
    }
}
