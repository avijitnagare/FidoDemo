//
//  ItemDetailView.swift
//  FidoDemo
//
//  Created by Avijit Nagare on 2026-05-04.
//
import SwiftUI
import SwiftData
import SDWebImageSwiftUI
import SDWebImage

struct FidoItemDetailView: View {

    @Environment(DataManager.self) private var dataManager
    let item: FidoItem

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            imageView
            HStack(spacing: 8) {
                Button {
                    toggleFavoriteAndSync()
                } label: {
                    Image(systemName: item.favorite ? "heart.fill" : "heart")
                        .foregroundStyle(item.favorite ? .red : .secondary)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
            if let desc = item.itemDescription, !desc.isEmpty {
                Text(desc)
                    .font(.body)
            }
            Spacer()
        }
        .padding()
        .navigationTitle(item.name ?? "Unknown Item")
    }
    
    private var imageView: some View {
        WebImage(
            url: URL(string: item.imageUrl ?? ""),
            context: [
                .imageThumbnailPixelSize: CGSize(width: 200, height: 200),
                .queryCacheType: SDImageCacheType.all.rawValue            // Ensures it checks Disk + Memory
            ]
        ) { image in
            image
                .resizable()
                .scaledToFit() // Prevents squishing dog photos
        } placeholder: {
            // Show this while downloading
            ZStack {
                Color.gray.opacity(0.1)
                ProgressView()
            }
        }
        .onSuccess { image, data, cacheType in
            // This proves the cache is working!
            print("Loaded from: \(cacheType == .disk ? "Disk" : "Network/Memory")")
        }
        .indicator(.activity)
        .transition(.fade(duration: 0.3))
    }

    // MARK: - Actions

    private func toggleFavoriteAndSync() {
        // Optimistic local toggle
        item.favorite.toggle()
        do {
            try dataManager.saveIfNeeded()
        } catch {
            // Revert if local save fails
            item.favorite.toggle()
            print("Failed to save favorite toggle locally: \(error)")
            return
        }

        // Sync to backend with PUT
        Task {
            let success = await APIService.shared.addFidoItem(item, isPost: false)
            if !success {
                await MainActor.run {
                    item.favorite.toggle()
                    do {
                        try dataManager.saveIfNeeded()
                    } catch {
                        print("Failed to revert favorite after server error: \(error)")
                    }
                }
            }
        }
    }
}
