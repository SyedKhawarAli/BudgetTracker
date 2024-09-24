//
//  BudgetEntry.swift
//  BudgetTracker
//
//  Created by shah on 24.9.2024.
//

import Foundation

struct BudgetEntry: Identifiable, Codable {
    var id = UUID()
    var amount: Double
    var description: String
}
