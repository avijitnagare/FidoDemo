//
//  ContentView.swift
//  FidoDemo
//
//  Created by Avijit Nagare on 2026-05-05.
//

import SwiftUI
import SwiftData

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
                               Text("Nav")
                            } label: {
                                FidoCard(item: item)
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
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton().disabled(true) // No effect in grid; disabled
                }
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
}
