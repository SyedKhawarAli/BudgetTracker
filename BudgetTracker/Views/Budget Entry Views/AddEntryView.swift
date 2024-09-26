//
//  AddEntryView.swift
//  BudgetTracker
//
//  Created by shah on 24.9.2024.
//

import SwiftUI

struct AddEntryView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: BudgetTrackerViewModel
    @State private var amountText: String = ""
    @State private var descriptionText: String = ""
    @State private var selectedType: BudgetType?
    @State private var showingAddType = false

    var body: some View {
        NavigationView {
            Form {
                TextField("Amount", text: $amountText)
                    .keyboardType(.decimalPad)
                TextField("Description", text: $descriptionText)

                Picker("Type", selection: $selectedType) {
                    ForEach(viewModel.unusedTypes) { type in
                        HStack {
                            Image(systemName: type.systemImage.lowercased())
                            Text(type.title)
                        }.tag(type as BudgetType?)
                    }
                }
            }
            .navigationTitle("New individual budget")
            .toolbarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            },trailing: Button("Save") {
                viewModel.addEntry(amountText: amountText, descriptionText: descriptionText, selectedType: selectedType){
                    presentationMode.wrappedValue.dismiss()
                }
            }.disabled(selectedType == nil))
            .errorAlert(error: $viewModel.error)
        }
    }
}
