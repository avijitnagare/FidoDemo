//
//  FidoDemoApp.swift
//  FidoDemo
//
//  Created by Avijit Nagare on 2026-05-05.
//

import SwiftUI
import SwiftData

@main
struct FidoDemoApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            FidoItem.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var dataManager: DataManager {
        DataManager(container: sharedModelContainer)
    }
    
    var body: some Scene {
        WindowGroup {
            FidoMainView(dataManager: dataManager)
        }
        .modelContainer(sharedModelContainer)
        .environment(dataManager)
    }
}
