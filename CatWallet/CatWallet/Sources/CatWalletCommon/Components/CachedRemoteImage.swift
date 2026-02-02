//
//  CachedRemoteImage.swift
//  CatWallet
//
//  Created by Andres Perdomo on 31/01/26.
//

import Combine
import ImageIO
import SwiftUI
import UIKit

struct CachedRemoteImage: View {
    let urlString: String?
    let fallbackURLString: String?
    let renderingMode: Image.TemplateRenderingMode?
    let targetSize: CGSize?

    @StateObject private var loader = ImageLoader()

    init(
        urlString: String?,
        fallbackURLString: String? = nil,
        renderingMode: Image.TemplateRenderingMode? = nil,
        targetSize: CGSize? = nil
    ) {
        self.urlString = urlString
        self.fallbackURLString = fallbackURLString
        self.renderingMode = renderingMode
        self.targetSize = targetSize
    }

    var body: some View {
        Group {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
                    .renderingMode(renderingMode)
                    .scaledToFit()
                    .transition(.opacity)
            } else {
                if loader.didFail {
                    CuteCatFailState()
                } else {
                    CuteCatPlaceholder()
                }
            }
        }
        .animation(.easeInOut(duration: 0.2), value: loader.image != nil)
        .onAppear {
            loader.load(
                primaryURLString: urlString,
                fallbackURLString: fallbackURLString,
                targetSize: targetSize
            )
        }
    }
}

private struct CuteCatPlaceholder: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.95, green: 0.92, blue: 1.00),
                            Color(red: 0.90, green: 0.97, blue: 0.98)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(Color.black.opacity(0.06), lineWidth: 1)
                )

            VStack(spacing: 8) {
                Image(systemName: "pawprint.fill")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Color.black.opacity(0.35))

                ProgressView()
                    .controlSize(.small)
                    .tint(Color.black.opacity(0.35))
            }
            .padding(12)
        }
    }
}

private struct CuteCatFailState: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 1.00, green: 0.93, blue: 0.95),
                            Color(red: 0.93, green: 0.95, blue: 1.00)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(Color.black.opacity(0.08), lineWidth: 1)
                )

            VStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.7))
                        .frame(width: 64, height: 64)
                        .overlay(
                            Circle()
                                .stroke(Color.black.opacity(0.06), lineWidth: 1)
                        )

                    Image(systemName: "pawprint.fill")
                        .font(.system(size: 26, weight: .semibold))
                        .foregroundStyle(Color.black.opacity(0.45))
                }

                Text(L10n.noImage)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.black.opacity(0.55))

                Text(L10n.keepScrolling)
                    .font(.caption)
                    .foregroundStyle(Color.black.opacity(0.45))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 14)
            }
            .padding(12)
        }
    }
}

final class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    @Published var didFail: Bool = false

    private var cancellable: AnyCancellable?

    func load(primaryURLString: String?, fallbackURLString: String?, targetSize: CGSize?) {
        didFail = false

        if let url = buildURL(from: primaryURLString),
           let cached = ImageCache.shared.get(url: url) {
            image = cached
            return
        }

        if let fallbackURL = buildURL(from: fallbackURLString),
           let cached = ImageCache.shared.get(url: fallbackURL) {
            image = cached
            return
        }

        download(primaryURLString, fallbackURLString: fallbackURLString, targetSize: targetSize)
    }

    private func download(_ urlString: String?, fallbackURLString: String?, targetSize: CGSize?) {
        guard let url = buildURL(from: urlString) else {
            downloadFallbackIfNeeded(fallbackURLString, targetSize: targetSize)
            return
        }

        if let cached = ImageCache.shared.get(url: url) {
            image = cached
            return
        }

        cancellable?.cancel()

        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { output -> Data in
                if let http = output.response as? HTTPURLResponse,
                   !(200...299).contains(http.statusCode) {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .tryMap { [weak self] data -> UIImage in
                guard let self else { throw URLError(.unknown) }
                return try self.decodeImage(data: data, targetSize: targetSize)
            }
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self else { return }
                    if case .failure = completion, self.image == nil {
                        self.downloadFallbackIfNeeded(fallbackURLString, targetSize: targetSize)
                    }
                },
                receiveValue: { [weak self] img in
                    guard let self else { return }
                    ImageCache.shared.set(img, for: url)
                    self.image = img
                }
            )
    }

    private func downloadFallbackIfNeeded(_ fallbackURLString: String?, targetSize: CGSize?) {
        guard let fallbackURL = buildURL(from: fallbackURLString) else {
            didFail = true
            return
        }

        if let cached = ImageCache.shared.get(url: fallbackURL) {
            image = cached
            return
        }

        cancellable?.cancel()

        cancellable = URLSession.shared.dataTaskPublisher(for: fallbackURL)
            .tryMap { output -> Data in
                if let http = output.response as? HTTPURLResponse,
                   !(200...299).contains(http.statusCode) {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .tryMap { [weak self] data -> UIImage in
                guard let self else { throw URLError(.unknown) }
                return try self.decodeImage(data: data, targetSize: targetSize)
            }
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self else { return }
                    if case .failure = completion, self.image == nil {
                        self.didFail = true
                    }
                },
                receiveValue: { [weak self] img in
                    guard let self else { return }
                    ImageCache.shared.set(img, for: fallbackURL)
                    self.image = img
                }
            )
    }

    private func decodeImage(data: Data, targetSize: CGSize?) throws -> UIImage {
        guard let targetSize else {
            guard let img = UIImage(data: data) else { throw URLError(.cannotDecodeContentData) }
            return img
        }

        let scale = UIScreen.main.scale
        let maxDimensionInPixels = max(targetSize.width, targetSize.height) * scale

        let cfData = data as CFData
        guard let source = CGImageSourceCreateWithData(cfData, nil) else {
            throw URLError(.cannotDecodeContentData)
        }

        let options: [CFString: Any] = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: Int(maxDimensionInPixels)
        ]

        guard let cgImage = CGImageSourceCreateThumbnailAtIndex(source, 0, options as CFDictionary) else {
            throw URLError(.cannotDecodeContentData)
        }

        return UIImage(cgImage: cgImage)
    }

    private func buildURL(from value: String?) -> URL? {
        guard let value, !value.isEmpty else { return nil }
        let normalized = value.hasPrefix("//") ? "https:\(value)" : value
        return URL(string: normalized)
    }

    deinit { cancellable?.cancel() }
}

final class ImageCache {
    static let shared = ImageCache()
    private let cache = NSCache<NSURL, UIImage>()

    private init() {}

    func get(url: URL) -> UIImage? {
        cache.object(forKey: url as NSURL)
    }

    func set(_ image: UIImage, for url: URL) {
        cache.setObject(image, forKey: url as NSURL)
    }
}
