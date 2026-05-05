//
//  Tost.swift
//  FidoDemo
//
//  Created by Avijit Nagare on 2026-05-05.
//



import SwiftUI
import Combine

class ToastManager: ObservableObject {
    static let shared = ToastManager() // The "Class Level" access
    
    @Published var show: Bool = false
    @Published var message: String = ""
    
    func show(text: String) {
        self.message = text
        withAnimation {
            self.show = true
        }
        
        // Auto-hide after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                self.show = false
            }
        }
    }
}
