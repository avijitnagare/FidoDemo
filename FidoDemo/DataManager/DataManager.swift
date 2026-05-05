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

    // Simple flag to avoid overlapping sync runs
    private var isSyncing = false

    init(container: ModelContainer) {
        self.container = container

        // Start background sync observation once DataManager is created
        startBackgroundSync()
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

// MARK: - Background sync for unsynced items
extension DataManager {

    // Call once on init to observe network changes and attempt initial sync
    func startBackgroundSync() {
        // Attempt an initial sync if we are already online
        if FidoNetworkManager.shared.isConnected {
            Task { await self.syncUnsyncedItems() }
        }

        // Observe connectivity changes
        FidoNetworkManager.shared.onStatusChange = { [weak self] connected in
            guard let self else { return }
            if connected {
                Task { await self.syncUnsyncedItems() }
            }
        }
    }

    // Fetch all items where syncStatus == false
    private func fetchUnsyncedItems() -> [FidoItem] {
        let descriptor = FetchDescriptor<FidoItem>(
            predicate: #Predicate { !$0.syncStatus },
            sortBy: [SortDescriptor(\.timestamp, order: .forward)]
        )
        do {
            return try modelContext.fetch(descriptor)
        } catch {
            print("Fetch unsynced items failed: \(error)")
            return []
        }
    }

    // Perform the actual sync
    private func syncUnsyncedItems() async {
        // Prevent overlapping runs
        if isSyncing { return }
        isSyncing = true
        defer { isSyncing = false }

        // Snapshot the items to sync
        let items = fetchUnsyncedItems()
        if items.isEmpty { return }

        for item in items {
            // Skip if we went offline mid-run
            if !FidoNetworkManager.shared.isConnected { break }

            let success = await APIService.shared.addFidoItem(item, isPost: true)
            if success {
                // Mark as synced and persist
                item.syncStatus = true
                do {
                    try modelContext.save()
                } catch {
                    // If save fails, revert the flag for this item so it will retry later
                    item.syncStatus = false
                    print("Failed to save after syncing item \(String(describing: item.id)): \(error)")
                }
            } else {
                // Stop early on a failure to avoid hammering the server; will retry on next connectivity change
                print("Sync failed for item \(String(describing: item.id)). Will retry later.")
                break
            }
        }
    }
}

// Small String helper
private extension String {

    var nilIfEmpty: String? { isEmpty ? nil : self }
}
