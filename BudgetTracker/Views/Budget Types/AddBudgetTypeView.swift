//
//  AddBudgetTypeView.swift
//  BudgetTracker
//
//  Created by shah on 24.9.2024.
//
import SwiftUI

struct AddBudgetTypeView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var budgetTypeHandler: BudgetTypeHandler
    @ObservedObject var viewModel: BudgetTypeViewModel
    @State private var title: String = ""
    @State private var systemImage: String = "questionmark.circle"

    var body: some View {
        NavigationView {
            Form {
                TextField("Title", text: $title)
                TextField("Icon (SFSymbol)", text: $systemImage)

                HStack {
                    Spacer()
                    Image(systemName: systemImage.lowercased())
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                    Spacer()
                }
            }
            .navigationTitle("Add New Type")
            .toolbarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            },trailing: Button("Save") {
                if viewModel.verifyBudgetTypeTitle(title) &&
                    viewModel.verifyBudgetTypeDoesNotExist(title, budgetTypeHandler.availableTypes) {
                    if budgetTypeHandler.addBudgetType(title: title, systemImage: systemImage.lowercased()) {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }.disabled(title.isEmpty))
            .errorAlert(error: $viewModel.error)
        }
    }
}
