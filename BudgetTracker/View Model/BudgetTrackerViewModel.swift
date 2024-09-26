//
//  BudgetTrackerViewModel.swift
//  BudgetTracker
//
//  Created by shah on 24.9.2024.
//

import Foundation
import SwiftUI

class BudgetTrackerViewModel: ObservableObject {
    @Published var entries: [BudgetEntry] = [] {
        didSet {
            saveEntries()
        }
    }
    
    var totalAmount: Double {
        entries.reduce(0) { $0 + $1.amount }
    }
    @Published var availableTypes: [BudgetType] = []
    
    private let maxTypes = 15
    
    init() {
        loadEntries()
        loadBudgetTypes()
    }
    
    var unusedTypes: [BudgetType] {
        let usedTypes = entries.map { $0.type }
        return availableTypes.filter { !usedTypes.contains($0) }
    }
}

// MARK: - BudgetEntry

extension BudgetTrackerViewModel {
    
    func addEntry(newEntry: BudgetEntry) {
        entries.append(newEntry)
    }
    
    func removeEntry(at indexSet: IndexSet) {
        entries.remove(atOffsets: indexSet)
    }
    
    func editEntry(at index: Int, amount: Double, description: String) {
        entries[index].amount = amount
        entries[index].description = description
    }
    
    func updateEntry(entry: BudgetEntry, amount: Double, descriptionText: String){
        if let index =  entries.firstIndex(where: { $0.id == entry.id }) {
            entries[index].amount = amount
            entries[index].description = descriptionText
        }
    }
    
    func saveEntries() {
        if let encoded = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(encoded, forKey: "budgetEntries")
        }
    }
    
    func loadEntries() {
        if let savedData = UserDefaults.standard.data(forKey: "budgetEntries"),
           let decoded = try? JSONDecoder().decode([BudgetEntry].self, from: savedData) {
            entries = decoded
        }
    }
    
}

// MARK: - BudgetTypes

extension BudgetTrackerViewModel {
    
    func saveBudgetTypes() {
        if let encoded = try? JSONEncoder().encode(availableTypes) {
            UserDefaults.standard.set(encoded, forKey: "budgetTypes")
        }
    }
    
    func loadBudgetTypes() {
        if let savedData = UserDefaults.standard.data(forKey: "budgetTypes"),
           let decoded = try? JSONDecoder().decode([BudgetType].self, from: savedData) {
            availableTypes = decoded
        }
        if availableTypes.isEmpty {
            availableTypes = [
                BudgetType(title: "Groceries", systemImage: "cart.fill"),
                BudgetType(title: "Shopping", systemImage: "bag.fill"),
                BudgetType(title: "Traveling", systemImage: "airplane")
            ]
            saveBudgetTypes()
        }
    }
    
    func addType(_ type: BudgetType) -> Bool {
        if availableTypes.count < maxTypes {
            availableTypes.append(type)
            saveBudgetTypes()
            return true
        }
        return false 
    }
}

// MARK: - total budget
extension BudgetTrackerViewModel {
    private struct TotalBudgetKey {
        static let totalBudget = "totalBudget"
    }
    
    func saveTotalBudget(totalBudget: Double) {
        UserDefaults.standard.set(totalBudget, forKey: TotalBudgetKey.totalBudget)
    }
    
    func loadTotalBudget() -> Double {
        let savedBudget = UserDefaults.standard.double(forKey: TotalBudgetKey.totalBudget)
        return savedBudget
    }
}
