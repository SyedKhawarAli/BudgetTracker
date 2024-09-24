//
//  BudgetViewModel.swift
//  BudgetTracker
//
//  Created by shah on 24.9.2024.
//

import Foundation
import SwiftUI

class BudgetViewModel: ObservableObject {
    @Published var entries: [BudgetEntry] = [] {
        didSet {
            saveEntries()
        }
    }
    
    var totalAmount: Double {
        entries.reduce(0) { $0 + $1.amount }
    }
    
    init() {
        loadEntries()
    }
    
    // Add a new entry
    func addEntry(amount: Double, description: String) {
        let newEntry = BudgetEntry(amount: amount, description: description)
        entries.append(newEntry)
    }
    
    // Remove an entry by ID
    func removeEntry(at indexSet: IndexSet) {
        entries.remove(atOffsets: indexSet)
    }
    
    // Save entries to UserDefaults
    func saveEntries() {
        if let encoded = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(encoded, forKey: "budgetEntries")
        }
    }
    
    // Load entries from UserDefaults
    func loadEntries() {
        if let savedData = UserDefaults.standard.data(forKey: "budgetEntries"),
           let decoded = try? JSONDecoder().decode([BudgetEntry].self, from: savedData) {
            entries = decoded
        }
    }
}
