//
//  ContentView.swift
//  BudgetTracker
//
//  Created by shah on 23.9.2024.
//

import SwiftUI

struct MainContentView: View {
    @State var totalBudget: Int = 0
    @ObservedObject var viewModel = BudgetTrackerViewModel()
    @State private var showingAddEntry = false
    @State private var isShowingSettings = false
    
    var body: some View {
        NavigationStack {
            VStack {
                totalBudgetView
                    .padding(.all, 8)
                if !viewModel.entries.isEmpty {
                    List {
                        ForEach($viewModel.entries){ $entry in
                            NavigationLink(destination: BudgetEntryDetailView(viewModel: viewModel, entry: $entry)) {
                                HStack {
                                    Image(systemName: entry.type.systemImage)
                                        .foregroundColor(.blue)
                                    Text(entry.type.title)
                                    Spacer()
                                    Text("$\(entry.amount, specifier: "%.2f")")
                                }
                            }}
                        .onDelete(perform: viewModel.removeEntry)
                    }
                    .background(
                        Color(.systemGray6)
                            .cornerRadius(16)
                    )
                    .scrollContentBackground(.hidden)
                } else {
                    Spacer()
                }
            }
            .padding()
            .navigationTitle("Budget Tracker")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        isShowingSettings = true
                    } label: {
                        Image(systemName: "gear")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add") {
                        showingAddEntry = true
                    }
                }
            }
            .sheet(isPresented: $showingAddEntry) {
                AddEntryView(viewModel: viewModel)
            }
            .navigationDestination(isPresented: $isShowingSettings) {
                SettingsView(viewModel: viewModel)
            }

        }
    }
    
    private var totalBudgetView: some View {
        ZStack {
            CardView {
                
            } content: {
                HStack {
                    VStack (alignment: .leading, spacing: 8){
                        Text("Total Budget")
                            .font(.body)
                        Text("$\(viewModel.totalAmount, specifier: "%.2f")")
                            .font(.title)
                        Spacer()
                        ProgressView(value: 0.7)
                            .scaleEffect(x: 1, y: 2, anchor: .center)

                    }
                    .padding(.all, 4)
                    Spacer()
                }
            }
        }
        .frame(maxHeight: 144)
    }
}

#Preview {
    MainContentView()
}

