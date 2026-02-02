//
//  CatWalletApp.swift
//  CatWallet
//
//  Created by Andres Perdomo on 30/01/26.
//

import SwiftUI

@main
struct CatWalletApp: App {
    var body: some Scene {
        WindowGroup {
            WelcomeContainerView(coordinator: NavigationCoordinator())
        }
    }
}
