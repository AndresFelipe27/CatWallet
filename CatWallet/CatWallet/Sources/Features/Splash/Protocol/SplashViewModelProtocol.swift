//
//  SplashViewModelProtocol.swift
//  CatWallet
//
//  Created by Andres Perdomo on 31/01/26.
//

import Combine

protocol SplashViewModelProtocol: AnyObject, ObservableObject {
    var isAnimating: Bool { get }

    func onAppear()
}
