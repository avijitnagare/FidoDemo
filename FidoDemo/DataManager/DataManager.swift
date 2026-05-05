//
//  DataManager.swift
//  FidoDemo
//
//  Created by Avijit Nagare on 2026-05-04.
//

import Foundation
import SwiftData
import Observation

@Observable
final class DataManager {

    let container: ModelContainer

    var modelContext: ModelContext {
        container.mainContext
    }

    init(container: ModelContainer) {
        self.container = container
    }

    // Example convenience APIs

    func insertNewItem(item: FidoItem) {
        modelContext.insert(item)
    }

    func delete(_ object: any PersistentModel) {
        modelContext.delete(object)
    }

    func saveIfNeeded() throws {
        try modelContext.save()
    }
}

// Small String helper
private extension String {

    var nilIfEmpty: String? { isEmpty ? nil : self }
}
