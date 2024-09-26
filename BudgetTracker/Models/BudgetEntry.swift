//
//  BudgetEntry.swift
//  BudgetTracker
//
//  Created by shah on 24.9.2024.
//

import Foundation

struct BudgetEntry: Identifiable, Codable, Equatable {
    var id = UUID()
    var amount: Double
    var description: String
    var type: BudgetType 
    
    static func == (lhs: BudgetEntry, rhs: BudgetEntry) -> Bool {
        lhs.id == rhs.id
    }
}
