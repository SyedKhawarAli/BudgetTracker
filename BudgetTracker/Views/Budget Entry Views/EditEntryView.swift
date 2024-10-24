//
//  EditEntryView.swift
//  BudgetTracker
//
//  Created by shah on 24.9.2024.
//

import SwiftUI

struct EditEntryView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var budgetTypeHandler: BudgetTypeHandler
    @ObservedObject var viewModel: BudgetTrackerViewModel
    @Binding var entry: BudgetEntry
    
    @State private var amountText: String = ""
    @State private var descriptionText: String = ""
    @State private var selectedType: BudgetType?
    
    var totalAmountWithoutCurrentEntryAmount: Decimal {
        return viewModel.totalAmount - entry.amount
    }

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
                    Picker("Type", selection: $selectedType) {
                        HStack {
                            Image(systemName: entry.type.systemImage)
                            Text(entry.type.title)
                        }.tag(entry.type as BudgetType?)
                        ForEach(budgetTypeHandler.unusedTypes(entries: viewModel.entries)) { type in
                            HStack {
                                Image(systemName: type.systemImage)
                                Text(type.title)
                            }.tag(type as BudgetType?)
                        }
                    }
                }
            }
            .background(Color(.systemGray6))
            .navigationTitle("Edit Entry")
            .toolbarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Save") {
                if let index = viewModel.entries.firstIndex(where: {$0.id == entry.id}) {
                    viewModel.entries[index].amount = 0
                }
                viewModel.updateEntry(entry: entry, amountText: amountText, descriptionText: descriptionText, selectedType: selectedType){
                    presentationMode.wrappedValue.dismiss()
                }
            })
            .onAppear {
                amountText = String(describing: entry.amount)
                descriptionText = entry.description
                selectedType = entry.type
            }
            .errorAlert(error: $viewModel.error)
        }
    }
    
    private var remainingBudgetView: some View {
        HStack {
            VStack (alignment: .leading, spacing: 8){
                HStack {
                    Text("Remaining:")
                        .font(.caption)
                    Text(Utils.getStringFromDecimal(viewModel.totalBudget - totalAmountWithoutCurrentEntryAmount ))
                        .font(.caption)
                    Spacer()
                    Text(Utils.getStringFromDecimal(viewModel.totalBudget))
                        .font(.caption)
                }
                ProgressView(value: NSDecimalNumber(decimal: (viewModel.totalBudget - totalAmountWithoutCurrentEntryAmount)/viewModel.totalBudget).doubleValue)
                    .scaleEffect(x: 1, y: 2, anchor: .center)

            }
            .padding()
            .background(Color(UIColor.systemBackground))
            .cornerRadius(8)
            if ((Utils.decimal(with: amountText) ?? 0) + totalAmountWithoutCurrentEntryAmount) > viewModel.totalBudget {
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
}
