//
//  EditEntryView.swift
//  BudgetTracker
//
//  Created by shah on 24.9.2024.
//

import SwiftUI

struct EditEntryView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: BudgetTrackerViewModel
    @Binding var entry: BudgetEntry
    
    @State private var amountText: String = ""
    @State private var descriptionText: String = ""
    @State private var selectedType: BudgetType?

    var body: some View {
        NavigationView {
            Form {
                TextField("Amount", text: $amountText)
                    .keyboardType(.decimalPad)
                TextField("Description", text: $descriptionText)
                Picker("Type", selection: $selectedType) {
                    ForEach(viewModel.availableTypes) { type in
                        HStack {
                            Image(systemName: type.systemImage)
                            Text(type.title)
                        }.tag(type as BudgetType?)
                    }
                }
            }
            .navigationTitle("Edit Entry")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Save") {
                viewModel.updateEntry(entry: entry, amountText: amountText, descriptionText: descriptionText, selectedType: selectedType){
                    presentationMode.wrappedValue.dismiss()
                }
            })
            .onAppear {
                amountText = String(format: "%.2f", entry.amount)
                descriptionText = entry.description
                selectedType = entry.type
            }
            .errorAlert(error: $viewModel.error)
        }
    }
}
