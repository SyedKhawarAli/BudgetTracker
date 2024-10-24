//
//  TotalBudgetDetailView.swift
//  BudgetTracker
//
//  Created by shah on 26.9.2024.
//

import SwiftUI

struct TotalBudgetDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: BudgetTrackerViewModel
    @State private var amountText: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            List {
                if viewModel.totalBudget > 0 {
                    Section(header: Text("Current total budget")) {
                        Text(Utils.getStringFromDecimal(viewModel.totalBudget))
                            .foregroundStyle(.secondary)
                    }
                }
                Section(header:
                    viewModel.totalBudget == 0 ? Text("Set your total budget") : Text("Update your total budget")
                ) {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            TextField("Amount", text: $amountText)
                                .keyboardType(.decimalPad)
                            
                            Button("Save") {
                                viewModel.saveTotalBudget(amountText: amountText){
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }
                            .disabled(amountText.isEmpty)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(amountText.isEmpty ? Color.gray : Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(4)
                        }
                        if viewModel.totalAmount > 0 {
                            Text("Note: Minimum budget required: \(Utils.getStringFromDecimal(viewModel.totalAmount))")
                                .font(.footnote)
                        }
                    }
                }
            }
            .cornerRadius(8)
            Spacer()
        }
        .navigationTitle("Total Budget")
        .navigationBarTitleDisplayMode(.inline)
        .errorAlert(error: $viewModel.error)
    }
}
