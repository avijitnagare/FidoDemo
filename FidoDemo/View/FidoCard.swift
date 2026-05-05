//
//  FidoCard.swift
//  FidoDemo
//
//  Created by Avijit Nagare on 2026-05-04.
//
import SwiftUI

struct FidoCard: View {
    var item: FidoItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
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
                Text(item.name?.isEmpty == false ? (item.name ?? "") : "Untitled")
                    .font(.headline)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            if let desc = item.itemDescription, !desc.isEmpty {
                Text(desc)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, minHeight: 110, alignment: .topLeading)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Color.secondary.opacity(0.15))
        )
        .contentShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}
