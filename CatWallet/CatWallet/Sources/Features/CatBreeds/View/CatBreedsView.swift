//
//  CatBreedsView.swift
//  CatWallet
//
//  Created by Andres Perdomo on 31/01/26.
//

import SwiftUI

struct CatBreedsView<ViewModel: CatBreedsViewModelProtocol>: View {
    @StateObject private var viewModel: ViewModel

    init(viewModel: @autoclosure @escaping () -> ViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel())
    }

    var body: some View {
        ZStack {
            PastelBackground()

            VStack(spacing: 12) {
                header
                content
            }
            .padding(.horizontal, 16)
            .padding(.top, 10)
            .padding(.bottom, 16)
        }
        .navigationBarHidden(true)
        .onAppear(perform: viewModel.onAppear)
        .sheet(isPresented: Binding(
            get: { viewModel.isLinkCardSheetPresented },
            set: { _ in viewModel.onRequestCloseLinkCard() }
        )) {
            LinkCardSheetView(
                isLoading: viewModel.isLinkingCard,
                errorMessage: viewModel.linkCardErrorMessage,
                onClose: viewModel.onRequestCloseLinkCard,
                onSubmit: viewModel.onSubmitTestCard
            )
        }
    }

    private var header: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(L10n.catBreedsTitle)
                    .font(.title2)
                    .fontWeight(.bold)

                Text(L10n.loadingBreeds)
                    .font(.caption)
                    .opacity(viewModel.isLoading ? 0.9 : 0)
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading && viewModel.breeds.isEmpty {
            LoadingStateView()
                .padding(.top, 24)
        } else if let message = viewModel.errorMessage {
            ErrorStateView(
                message: message,
                onRetry: viewModel.onTapRetry
            )
            .padding(.top, 24)
        } else if viewModel.breeds.isEmpty {
            EmptyStateView()
                .padding(.top, 24)
        } else {
            breedsGrid
        }
    }

    private var breedsGrid: some View {
        ScrollView(showsIndicators: false) {
            let columns = [GridItem(.adaptive(minimum: 320), spacing: 14)]

            LazyVGrid(columns: columns, spacing: 14) {
                ForEach(viewModel.breeds) { item in
                    CatBreedCardView(
                        breed: item.breed,
                        isFavorite: item.isFavorite,
                        onToggleFavorite: { viewModel.onToggleFavorite(id: item.id) }
                    )
                }
            }
            .padding(.top, 6)
        }
    }
}
