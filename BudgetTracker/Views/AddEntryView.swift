//
//  AddEntryView.swift
//  BudgetTracker
//
//  Created by Khawar Ali on 24.9.2024.
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
                            Image(systemName: type.systemImage)
                            Text(type.title)
                        }.tag(type as BudgetType?)
                    }
                }
                if viewModel.availableTypes.count < 15 {
                    Button("Add New Type") {
                        showingAddType = true
                    }
                    .sheet(isPresented: $showingAddType) {
                        AddBudgetTypeView(viewModel: viewModel)
                    }
                } else {
                    Text("Maximum of 15 types reached")
                        .foregroundColor(.red)
                }
            }
            .navigationTitle("New indiviual budget")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            },trailing: Button("Save") {
                if let amount = Double(amountText), let type = selectedType {
                    let newEntry = BudgetEntry(amount: amount, description: descriptionText, type: type)
                    viewModel.addEntry(newEntry: newEntry)
                    selectedType = nil
                    presentationMode.wrappedValue.dismiss()
                }
            }.disabled(selectedType == nil))
        }
    }
}
