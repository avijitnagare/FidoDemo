//
//  ContentView.swift
//  FidoDemo
//
//  Created by Avijit Nagare on 2026-05-05.
//

import SwiftUI
import SwiftData

struct FidoMainView: View {
    
    @Environment(DataManager.self) private var dataManager
    
    @Query(sort: \FidoItem.timestamp, order: .forward) private var items: [FidoItem]
    
    // 1. Declare without an initial value
    @StateObject private var mainViewModel: FidoMainViewModel
    init(dataManager: DataManager) {
        _mainViewModel = StateObject(wrappedValue: FidoMainViewModel(dataManager: dataManager))
    }
    
    private let columns = [
        GridItem(.adaptive(minimum: 180), spacing: 12)
    ]
    @State private var showingAdd = false
    
    var body: some View {
        NavigationSplitView {
            ZStack {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(items) { item in
                            NavigationLink {
                                FidoItemDetailView(item: item)
                                    .padding()
                            } label: {
                                FidoCard(item: item) { tappedItem in
                                    toggleFavoriteAndSave(tappedItem)
                                }
                            }
                            .buttonStyle(.plain) // Keep card look
                            .contextMenu {
                                Button(role: .destructive) {
                                    delete(item: item)
                                } label: {
                                    Label(mainViewModel.deleteActionTitle, systemImage: "trash")
                                }
                            }
                        }
                    }
                    .padding(12)
                }
                .opacity(mainViewModel.isLoading ? 0.4 : 1.0)
                if mainViewModel.isLoading {
                    ProgressView("Fetching items...")
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(8)
                }
            }
            
            .navigationTitle(mainViewModel.navTitle)
            .toolbar {
                ToolbarItem {
                    Button {
                        showingAdd = true
                    } label: {
                        Label(mainViewModel.addItemTitle, systemImage: "plus")
                    }
                }
            }
            .onAppear() {
                mainViewModel.getAllItems()
            }
        } detail: {
            Text("Select an item")
        }
        .sheet(isPresented: $showingAdd) {
            FidoAddItemView()
        }
    }
    
    // MARK: - Actions
    
    private func delete(item: FidoItem) {
        withAnimation {
            mainViewModel.deleteFido(item: item)
        }
    }
    
    private func toggleFavoriteAndSave(_ item: FidoItem) {
        // Optimistic local toggle
        item.favorite.toggle()
        do {
            try dataManager.saveIfNeeded()
        } catch {
            // Revert on failure to save locally
            item.favorite.toggle()
            print("Failed to save favorite toggle locally: \(error)")
            return
        }
        // Sync to backend
        Task {
            // Use PUT (isPost: false) to update existing item on server
            let success = await APIService.shared.addFidoItem(item, isPost: false)
            if !success {
                // Revert if server update failed
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
