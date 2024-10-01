//
//  BudgetTrackerApp.swift
//  BudgetTracker
//
//  Created by shah on 23.9.2024.
//

import SwiftUI

@main
struct BudgetTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            MainContentView()
                .environmentObject(ThemeHandler())
                .environmentObject(BudgetTypeHandler())
        }
    }
}
