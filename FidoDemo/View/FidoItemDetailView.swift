//
//  ItemDetailView.swift
//  FidoDemo
//
//  Created by Avijit Nagare on 2026-05-04.
//
import SwiftUI
import SwiftData

struct FidoItemDetailView: View {

    let item: FidoItem

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            AsyncImage(url: URL(string: item.imageUrl ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
            }
            
            HStack(spacing: 8) {
                Image(systemName: item.isFavorite ? "heart.fill" : "heart")
                    .foregroundStyle(item.isFavorite ? .red : .secondary)
               
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
}

