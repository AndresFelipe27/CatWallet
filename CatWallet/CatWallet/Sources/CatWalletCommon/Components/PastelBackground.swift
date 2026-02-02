//
//  PastelBackground.swift
//  CatWallet
//
//  Created by Andres Perdomo on 31/01/26.
//

import SwiftUI

struct PastelBackground: View {
    var body: some View {
        LinearGradient(
            colors: [
                Color.white,
                Color.white.opacity(0.9),
                Color.white.opacity(0.85)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .overlay(
            RadialGradient(
                colors: [
                    Color.pink.opacity(0.18),
                    Color.clear
                ],
                center: .topLeading,
                startRadius: 60,
                endRadius: 520
            )
        )
        .overlay(
            RadialGradient(
                colors: [
                    Color.blue.opacity(0.14),
                    Color.clear
                ],
                center: .bottomTrailing,
                startRadius: 60,
                endRadius: 520
            )
        )
        .ignoresSafeArea()
    }
}
