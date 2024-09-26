//
//  AddBudgetTypeView.swift
//  BudgetTracker
//
//  Created by Khawar Ali on 24.9.2024.
//
import SwiftUI

struct AddBudgetTypeView: View {
    @ObservedObject var viewModel: BudgetTrackerViewModel
    @State private var title: String = ""
    @State private var systemImage: String = "questionmark.circle"  // Default icon
    @Environment(\.presentationMode) var presentationMode

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
            .navigationBarItems(trailing: Button("Save") {
                if !title.isEmpty {
                    let newType = BudgetType(title: title, systemImage: systemImage)
                    if viewModel.addType(newType) {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            })
        }
    }
}
