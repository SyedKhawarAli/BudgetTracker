//
//  ManageTypesView.swift
//  BudgetTracker
//
//  Created by Khawar Ali on 25.9.2024.
//

import SwiftUI

struct ManageTypesView: View {
    @ObservedObject var viewModel: BudgetTrackerViewModel
    @State private var showingAddType = false
    
    var body: some View {
        List {
            ForEach(viewModel.availableTypes) { type in
                HStack {
                    Image(systemName: type.systemImage)
                    Text(type.title)
                }
            }
            .onDelete(perform: deleteType)
            
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
        .navigationTitle("Manage Types")
        .toolbar {
            EditButton()
        }
    }

    private func deleteType(at offsets: IndexSet) {
        viewModel.availableTypes.remove(atOffsets: offsets)
        viewModel.saveBudgetTypes()
    }
}
