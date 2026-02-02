//
//  NavigationCoordinator.swift
//  CatWallet
//
//  Created by Andres Perdomo on 30/01/26.
//

import Combine
import Foundation
import SwiftUI

public struct NavigationItem: Hashable {
    let id = UUID()
    let view: AnyView
    let tag: String?

    public init<V: View>(_ view: V, tag: NavigationTag? = nil) {
        self.view = AnyView(view)
        self.tag = tag?.rawValue
    }

    public static func == (lhs: NavigationItem, rhs: NavigationItem) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

class NavigationCoordinator: ObservableObject {
    @Published var path = [NavigationItem]()
    @Published var isPresented: Bool = false

    init() {}

    func open() {
        isPresented = true
        path = []
    }

    func close() {
        isPresented = false
        path = []
    }

    func push<V: View>(_ view: V, tag: NavigationTag? = nil) {
        path.append(NavigationItem(view, tag: tag))
    }

    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }

    func popToRoot() {
        path = []
    }

    func popTo(steps: Int) {
        guard steps > 0, steps < path.count else { return }
        path.removeLast(steps)
    }

    func popTo(tag: NavigationTag) {
        guard let index = path.firstIndex(where: { $0.tag == tag.rawValue }) else { return }
        path = Array(path.prefix(upTo: index + 1))
    }

    func popToOrFirstView(tag: NavigationTag) {
        if let index = path.firstIndex(where: { $0.tag == tag.rawValue }) {
            path = Array(path.prefix(upTo: index + 1))
        } else {
            path = []
        }
    }

    func goToFirstView() {
        guard let firstItem = path.first else { return }
        path = [firstItem]
    }
}
