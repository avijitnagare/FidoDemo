//
//  Item.swift
//  FidoDemo
//
//  Created by Avijit Nagare on 2026-05-05.
//

import Foundation
import SwiftData

@Model
final class FidoItem: Codable {
    @Attribute(.unique) var id: Int?
    var timestamp: Date
    var name: String?
    var favorite: Bool = false
    var itemDescription: String?
    var imageUrl: String?
    var syncStatus: Bool = false
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
    
    // Standard Init for local creation
    init(timestamp: Date, name: String? = nil, favorite: Bool = false, itemDescription: String, imageUrl: String) {
        self.timestamp = timestamp
        self.name = name
        self.favorite = favorite
        self.itemDescription = itemDescription
        self.imageUrl = imageUrl
    }

    enum CodingKeys: String, CodingKey {
        case id, name, isFavorite, itemDescription, imageUrl, syncStatus
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.favorite = try container.decodeIfPresent(Bool.self, forKey: .isFavorite) ?? false
        self.itemDescription = try container.decodeIfPresent(String.self, forKey: .itemDescription)
        self.imageUrl = try container.decodeIfPresent(String.self, forKey: .imageUrl)
        self.syncStatus = try container.decodeIfPresent(Bool.self, forKey: .syncStatus) ?? false
        // Since the server doesn't provide a timestamp, we generate it on decode
        self.timestamp = Date()
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(favorite, forKey: .isFavorite)
        try container.encode(itemDescription, forKey: .itemDescription)
        try container.encode(imageUrl, forKey: .imageUrl)
        try container.encode(syncStatus, forKey: .syncStatus)
    }
}
