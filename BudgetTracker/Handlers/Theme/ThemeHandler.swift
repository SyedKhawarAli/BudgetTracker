//
//  ThemeHandler.swift
//  BudgetTracker
//
//  Created by shah on 1.10.2024.
//

import Foundation

enum Theme: String, CaseIterable, Identifiable {
    case light = "Light"
    case dark = "Dark"
    case system = "System"
    
    var id: String { self.rawValue }
}

@MainActor
class ThemeHandler: ObservableObject {
    // MARK: Variables
    @Published var appTheme: Theme = .light{
        didSet {
            saveAppTheme()
        }
    }
    
    // MARK: init method

    init() {
        loadAppTheme()
    }
    
    // MARK: Private methods

    private func saveAppTheme() {
        UserDefaults.standard.set(appTheme.rawValue, forKey: BudgetKeys.appTheme)
    }
    
    private func loadAppTheme() {
        appTheme = Theme(rawValue: UserDefaults.standard.string(forKey: BudgetKeys.appTheme) ?? Theme.system.rawValue) ?? .system
    }
}
