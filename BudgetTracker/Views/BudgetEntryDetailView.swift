//
//  BudgetEntryDetailView.swift
//  BudgetTracker
//
//  Created by Khawar Ali on 24.9.2024.
//

import SwiftUI

struct BudgetEntryDetailView: View {
    @ObservedObject var viewModel: BudgetTrackerViewModel
    @Binding var entry: BudgetEntry  // Bind to the selected entry
    
    @State private var isEditing = false  // Controls the display of the Edit screen
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Description")
                .font(.headline)
            Text(entry.description)
            
            Text("Amount")
                .font(.headline)
            Text("$\(entry.amount, specifier: "%.2f")")
            
            Spacer()
        }
        .padding()
        .navigationTitle("Entry Details")
        .toolbar {
            // Add "Edit" button in the toolbar
            Button("Edit") {
                isEditing = true  // Trigger the edit sheet
            }
        }
        // Present the EditEntryView when the "Edit" button is tapped
        .sheet(isPresented: $isEditing) {
            EditEntryView(viewModel: viewModel, entry: $entry)
        }
    }
}
