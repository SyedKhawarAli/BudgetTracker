//
//  Constants.swift
//  BudgetTracker
//
//  Created by shah on 26.9.2024.
//

struct Constants {
    static let maxDescriptionLength = 15
    static let maxBudgetTypeTitleLength = 15

}

enum Theme: String, CaseIterable, Identifiable {
    case light = "Light"
    case dark = "Dark"
    case system = "System"
    
    var id: String { self.rawValue }
}
