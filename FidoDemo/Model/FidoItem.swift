//
//  Item.swift
//  FidoDemo
//
//  Created by Avijit Nagare on 2026-05-05.
//

import Foundation
import SwiftData

@Model
final class FidoItem {
    var timestamp: Date
    var name: String?
    var isFavorite: Bool = false
    var itemDescription: String?
    var imageUrl: String?
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
