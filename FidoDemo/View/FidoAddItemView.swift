//
//  FidoAddItemView.swift
//  FidoDemo
//
//  Created by Avijit Nagare on 2026-05-04.
//
import SwiftUI
import SwiftData

struct FidoAddItemView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(DataManager.self) private var dataManager
    
    private var addItemViewModel = FidoAddItemViewModel()

    @State private var nameText: String = ""
    @State private var isFavorite: Bool = false
    @State private var descriptionText: String = ""
    @State private var isShowingAlert = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section() {
                    TextField(addItemViewModel.nameTitle, text: $nameText)
                        .textInputAutocapitalization(.words)
                        .autocorrectionDisabled(false)
                    Toggle(addItemViewModel.favoriteTitle, isOn: $isFavorite)
                    VStack(alignment: .leading, spacing: 8) {
                        Text(addItemViewModel.descriptionTitle)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        TextEditor(text: $descriptionText)
                            .frame(minHeight: 120)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.secondary.opacity(0.2))
                            )
                            .padding(.top, 4)
                    }
                }
            }
            .alert("Alert!!", isPresented: $isShowingAlert, actions: {
                
            }, message: {
                Text("Enter a name and description")
            })
            .navigationTitle("Add Item")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                }
            }
        }
    }
    
    private func save() {
        if nameText.isEmpty ||
            descriptionText.isEmpty {
            isShowingAlert = true
            return
        }
        dataManager.insertNewItem(
            name: nameText,
            isFavorite: isFavorite,
            description: descriptionText
        )
        dismiss()
    }
}
