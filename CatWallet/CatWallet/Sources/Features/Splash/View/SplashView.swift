//
//  SplashView.swift
//  CatWallet
//
//  Created by Andres Perdomo on 31/01/26.
//

import SwiftUI

struct SplashView<ViewModel>: View where ViewModel: SplashViewModelProtocol {
    @StateObject private var viewModel: ViewModel

    init(viewModel: @autoclosure @escaping () -> ViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel())
    }

    var body: some View {
        ZStack {
            background

            VStack(spacing: 14) {
                logo
                    .padding(.bottom, 6)

                Text(L10n.helloCatWallet)
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .multilineTextAlignment(.center)

                Text(L10n.exploreCatBreedsSubtitle)
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .opacity(0.85)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 20)
        }
        .ignoresSafeArea()
        .onAppear(perform: viewModel.onAppear)
    }

    private var background: some View {
        LinearGradient(
            colors: [
                Color(red: 0.96, green: 0.70, blue: 0.78),
                Color(red: 0.74, green: 0.82, blue: 0.98),
                Color(red: 0.77, green: 0.93, blue: 0.86)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .overlay(
            FloatingBubbles()
                .opacity(0.35)
        )
    }

    private var logo: some View {
        ZStack {
            Circle()
                .fill(.white.opacity(0.22))
                .frame(width: 112, height: 112)

            Image(systemName: "cat.fill")
                .font(.system(size: 44, weight: .bold))
                .symbolRenderingMode(.hierarchical)
                .scaleEffect(viewModel.isAnimating ? 1.03 : 0.98)
                .rotationEffect(.degrees(viewModel.isAnimating ? 6 : -6))
                .animation(
                    .easeInOut(duration: 1.2).repeatForever(autoreverses: true),
                    value: viewModel.isAnimating
                )
        }
        .shadow(radius: 18, y: 10)
        .accessibilityHidden(true)
    }
}

private struct FloatingBubbles: View {
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size

            ZStack {
                bubble(size: 140, coorX: size.width * 0.15, coorY: size.height * 0.20)
                bubble(size: 90, coorX: size.width * 0.82, coorY: size.height * 0.28)
                bubble(size: 110, coorX: size.width * 0.78, coorY: size.height * 0.78)
                bubble(size: 70, coorX: size.width * 0.18, coorY: size.height * 0.80)
            }
        }
    }

    private func bubble(size: CGFloat, coorX: CGFloat, coorY: CGFloat) -> some View {
        Circle()
            .fill(.white.opacity(0.22))
            .frame(width: size, height: size)
            .position(x: coorX, y: coorY)
            .blur(radius: 0.5)
    }
}

#Preview {
    SplashView(viewModel: SplashViewModel(coordinator: NavigationCoordinator()))
}
