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
            VStack {
                remainingBudgetView
                    .padding(.horizontal)
                    .padding(.top)

                Form {
                    TextField("Amount", text: $amountText)
                        .keyboardType(.decimalPad)
                    TextField("Description", text: $descriptionText)
                    
                    budgetTypePickerView
                }
            }
            .background(Color(.systemGray6))
            .navigationTitle("Add individual budget")
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
    
    private var remainingBudgetView: some View {
        HStack {
            VStack (alignment: .leading, spacing: 8){
                HStack {
                    Text("Remaining:")
                        .font(.caption)
                    Text("$\(viewModel.totalBudget - viewModel.totalAmount, specifier: "%.2f")")
                        .font(.caption)
                    Spacer()
                    Text("$\(viewModel.totalBudget, specifier: "%.2f")")
                        .font(.caption)
                }
                ProgressView(value: (viewModel.totalBudget - viewModel.totalAmount)/viewModel.totalBudget)
                    .scaleEffect(x: 1, y: 2, anchor: .center)
            }
            .padding()
            .background(Color(UIColor.systemBackground))
            .cornerRadius(8)
            if ((Double(amountText) ?? 0) + viewModel.totalAmount) > viewModel.totalBudget {
                Button {
                    viewModel.totalBudget += 50
                } label: {
                    Text("+50")
                        .padding(.all, 8)
                }
                .background(Color.accentColor)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        }
    }
    
    private var budgetTypePickerView: some View {
        ZStack {
            if viewModel.unusedTypes.count > 0 {
                Picker("Type", selection: $selectedType) {
                    Text("Select a Type").tag(BudgetType?.none)
                    ForEach(viewModel.unusedTypes) { type in
                        HStack {
                            Image(systemName: type.systemImage.lowercased())
                            Text(type.title)
                        }.tag(type as BudgetType?)
                    }
                }
            } else {
                if viewModel.availableTypes.count < 15 {
                    Text("No unused types available. Please add a new type")
                        .foregroundStyle(.secondary)
                    Button("Add New Type") {
                        showingAddType = true
                    }
                    .sheet(isPresented: $showingAddType) {
                        AddBudgetTypeView(viewModel: viewModel)
                    }
                } else {
                    Text("Maximum of \(viewModel.maxTypes) types reached")
                        .foregroundColor(.red)
                    Text("delete some types to add more")
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}
