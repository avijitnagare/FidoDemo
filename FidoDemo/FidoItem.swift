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
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
