//
//  EditEntryView.swift
//  BudgetTracker
//
//  Created by Khawar Ali on 24.9.2024.
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
                    ForEach(viewModel.unusedTypes) { type in
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
                if let amount = Double(amountText), let type = selectedType {
                    entry.amount = amount
                    entry.description = descriptionText
                    entry.type = type
                }
            })
            .onAppear {
                amountText = String(format: "%.2f", entry.amount)
                descriptionText = entry.description
                selectedType = entry.type
            }
        }
    }
}
