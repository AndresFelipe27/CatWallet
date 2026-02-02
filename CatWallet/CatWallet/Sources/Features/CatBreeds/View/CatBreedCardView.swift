//
//  CatBreedCardView.swift
//  CatWallet
//
//  Created by Andres Perdomo on 31/01/26.
//

import SwiftUI

struct CatBreedCardView: View {
    let breed: CatBreed
    let isFavorite: Bool
    let onToggleFavorite: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            headerImage

            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .top, spacing: 10) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(breed.name)
                            .font(.headline)
                            .fontWeight(.bold)

                        Text("\(L10n.origin): \(breed.origin)")
                            .font(.caption)
                            .opacity(0.85)
                    }

                    Spacer()

                    Button(action: onToggleFavorite) {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .font(.system(size: 18, weight: .semibold))
                            .padding(10)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                    .animation(.easeInOut(duration: 0.15), value: isFavorite)
                    .accessibilityLabel(isFavorite ? L10n.removeFromFavorites : L10n.addToFavorites)
                }

                if !breed.temperament.isEmpty {
                    InfoPillRow(
                        title: L10n.temperament,
                        value: breed.temperament
                    )
                }

                if !breed.description.isEmpty {
                    Text(breed.description)
                        .font(.subheadline)
                        .opacity(0.9)
                        .lineLimit(3)
                }

                HStack(spacing: 10) {
                    InfoChip(
                        icon: "clock",
                        text: "\(L10n.lifeSpan): \(breed.lifeSpan) \(L10n.years)"
                    )
                    Spacer()
                }
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 12)
        }
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: [
                            Color.pink.opacity(0.45),
                            Color.purple.opacity(0.35),
                            Color.blue.opacity(0.35)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 4
                )
        )
    }

    private var headerImage: some View {
        ZStack(alignment: .bottomLeading) {
            CachedRemoteImage(
                urlString: breed.imageURLString,
                fallbackURLString: breed.fallbackImageURLString,
                targetSize: CGSize(width: 420, height: 170)
            )

            LinearGradient(
                colors: [Color.black.opacity(0.0), Color.black.opacity(0.35)],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 170)
        }
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .padding(10)
    }
}
