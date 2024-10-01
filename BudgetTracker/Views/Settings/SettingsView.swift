//
//  SettingsView.swift
//  BudgetTracker
//
//  Created by shah on 25.9.2024.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var themeHandler: ThemeHandler
    @ObservedObject var viewModel: BudgetTrackerViewModel
    @State private var showingPrivacyPolicy = false
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            Form {
                Section(header: Text("Budget Types")) {
                    Button {
                        navigationPath.append("ManageTypesView")
                    } label: {
                        HStack {
                            Image(systemName: "list.bullet")
                            Text("Manage Budget Types")
                        }
                    }
                }
                
                Section(header: Text("Appearance")) {
                    Picker("Theme", selection: $themeHandler.appTheme) {
                        ForEach(Theme.allCases) { theme in
                            Text(theme.rawValue).tag(theme)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .onChange(of: themeHandler.appTheme, { oldValue, newValue in
                        themeHandler.appTheme = newValue
                    })
                }
                
                Section(header: Text("App Information")) {
                    HStack {
                        Image(systemName: "info.circle")
                        Text("Version")
                        Spacer()
                        Text(Utils.appVersion)
                            .foregroundColor(.gray)
                    }
                }
                
                Section(header: Text("Privacy")) {
                    Button(action: {
                        showingPrivacyPolicy.toggle()
                    }) {
                        HStack {
                            Image(systemName: "lock.shield")
                            Text("Privacy Policy")
                        }
                    }
                    .sheet(isPresented: $showingPrivacyPolicy) {
                        PrivacyPolicyView()
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationDestination(for: String.self) { destination in
                if destination == "ManageTypesView" {
                    ManageTypesView(viewModel: BudgetTypeViewModel())
                }
            }
        }
    }
}
