//
//  BudgetEntryDetailView.swift
//  BudgetTracker
//
//  Created by shah on 24.9.2024.
//

import SwiftUI

struct BudgetEntryDetailView: View {
    @ObservedObject var viewModel: BudgetTrackerViewModel
    @Binding var entry: BudgetEntry
    @State private var isEditing = false
    
    var body: some View {
        VStack(spacing: 20) {
            List {
                Section {
                    HStack {
                        Text("Description")
                            .font(.headline)
                        Spacer()
                        Text(entry.description)
                    }
                    HStack {
                        Text("Amount")
                            .font(.headline)
                        Spacer()
                        Text("$\(entry.amount, specifier: "%.2f")")
                    }
                }
            }
            Spacer()
        }
        .padding()
        .navigationTitle(entry.type.title)
        .toolbar {
            Button("Edit") {
                isEditing = true
            }
        }
        .sheet(isPresented: $isEditing) {
            EditEntryView(viewModel: viewModel, entry: $entry)
        }
    }
}
