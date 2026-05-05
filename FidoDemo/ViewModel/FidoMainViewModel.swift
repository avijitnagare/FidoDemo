//
//  FidoMainViewModel.swift
//  FidoDemo
//
//  Created by Avijit Nagare on 2026-05-05.
//

import Foundation
import SwiftData
import Combine


class FidoMainViewModel: ObservableObject {
    private let dataManager: DataManager
    @Published var isLoading: Bool = false

    init(dataManager: DataManager) {
        self.dataManager = dataManager
    }
    
    
    func deleteFido(item: FidoItem) {
        dataManager.delete(item)
    }
    
    func getAllItems() {
        
    }
}

extension FidoMainViewModel {
    var navTitle: String { "Marketplace" }
    var deleteActionTitle: String { "Delete" }
    var addItemTitle: String { "Add Item" }
}
