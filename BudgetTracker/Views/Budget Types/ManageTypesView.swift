//
//  ManageTypesView.swift
//  BudgetTracker
//
//  Created by shah on 25.9.2024.
//

import SwiftUI

struct ManageTypesView: View {
    @EnvironmentObject var budgetTypeHandler: BudgetTypeHandler
    @ObservedObject var viewModel: BudgetTypeViewModel
    @State private var showingAddType = false
    
    var body: some View {
        List {
            ForEach(budgetTypeHandler.availableTypes) { type in
                HStack {
                    Image(systemName: type.systemImage.lowercased())
                    Text(type.title)
                }
            }
            .onDelete(perform: deleteType)
            
            if budgetTypeHandler.availableTypes.count < 15 {
                Button("Add New Type") {
                    showingAddType = true
                }
                .sheet(isPresented: $showingAddType) {
                    AddBudgetTypeView(viewModel: viewModel)
                }
            } else {
                Text("Maximum of \(Constants.maxBudgetTypes) types reached")
                    .foregroundColor(.red)
            }
        }
        .navigationTitle("Manage Types")
        .toolbar {
            EditButton()
        }
    }

    private func deleteType(at offsets: IndexSet) {
        budgetTypeHandler.availableTypes.remove(atOffsets: offsets)
    }
}
