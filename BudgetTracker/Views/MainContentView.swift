//
//  ContentView.swift
//  BudgetTracker
//
//  Created by shah on 23.9.2024.
//

import SwiftUI

struct MainContentView: View {
    @EnvironmentObject var themeHandler: ThemeHandler
    @ObservedObject var viewModel = BudgetTrackerViewModel()
    @State private var showingAddEntry = false
    @State private var isShowingSettings = false
    @State private var isShowingCardDetails = false

    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.totalBudget <= 0 {
                    Spacer()
                    Button {
                        isShowingCardDetails = true
                    } label: {
                        Text("Set up your total budget")
                            .font(.headline)
                    }
                    .frame(height: 96)
                    .frame(maxWidth: .infinity)
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding()
                    
                } else {
                    totalBudgetView
                        .padding(.vertical, 8)
                    if !viewModel.entries.isEmpty {
                        List {
                            ForEach($viewModel.entries){ $entry in
                                NavigationLink(destination: BudgetEntryDetailView(viewModel: viewModel, entry: $entry)) {
                                    HStack {
                                        Image(systemName: entry.type.systemImage.lowercased())
                                            .foregroundColor(.accentColor)
                                        Text(entry.type.title)
                                        Spacer()
                                        Text(Utils.getStringFromDecimal(entry.amount))
                                    }
                                }}
                            .onDelete(perform: viewModel.removeEntry)
                        }
                        .background(
                            Color(.systemGray6)
                                .cornerRadius(8)
                        )
                        .scrollContentBackground(.hidden)
                    } else {
                        Button {
                            showingAddEntry = true
                        } label: {
                            Text("Add individual entries")
                                .font(.headline)
                        }
                        .frame(height: 64)
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.top, 8)
                        
                        Spacer()
                    }
                }
            }
            .padding()
            .navigationTitle("Budget Tracker")
            .preferredColorScheme(colorScheme)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        isShowingSettings = true
                    } label: {
                        Image(systemName: "gear")
                    }
                }
                if !viewModel.entries.isEmpty {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Add") {
                            showingAddEntry = true
                        }
                    }
                }
            }
            .sheet(isPresented: $showingAddEntry) {
                AddEntryView(viewModel: viewModel)
            }
            .navigationDestination(isPresented: $isShowingSettings) {
                SettingsView(viewModel: viewModel)
            }
            .navigationDestination(isPresented: $isShowingCardDetails) {
                TotalBudgetDetailView(viewModel: viewModel)
            }
        }
        
        var colorScheme: ColorScheme? {
            switch themeHandler.appTheme {
            case .light:
                return .light
            case .dark:
                return .dark
            case .system:
                return nil
            }
        }
    }
    
    private var totalBudgetView: some View {
        ZStack {
            
            CardView {
                isShowingCardDetails = true
            } content: {
                HStack {
                    VStack (alignment: .leading, spacing: 8){
                        Text("Remaining")
                            .font(.caption)
                        Text(Utils.getStringFromDecimal(viewModel.totalBudget - viewModel.totalAmount))
                            .font(.title)
                        Spacer()
                        HStack {
                            Text("Total Budget")
                                .font(.caption)
                            Spacer()
                            Text(Utils.getStringFromDecimal(viewModel.totalBudget))
                                .font(.caption)
                        }
                        if (viewModel.totalBudget - viewModel.totalAmount)/viewModel.totalBudget > 0 {
                            ProgressView(value: NSDecimalNumber(decimal: (viewModel.totalBudget - viewModel.totalAmount)/viewModel.totalBudget).doubleValue)
                                .scaleEffect(x: 1, y: 2, anchor: .center)
                        }
                    }
                    .padding(.all, 4)
                    Spacer()
                }
            }
            .frame(maxHeight: 144)
        }
    }
}

#Preview {
    MainContentView()
}

