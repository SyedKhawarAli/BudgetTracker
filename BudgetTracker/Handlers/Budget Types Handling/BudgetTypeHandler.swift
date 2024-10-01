//
//  BudgetTypeHandler.swift
//  BudgetTracker
//
//  Created by shah on 1.10.2024.
//

import Foundation

@MainActor
class BudgetTypeHandler: ObservableObject {
    // MARK: Variables

    @Published var availableTypes: [BudgetType] = []{
        didSet {
            saveBudgetTypes()
        }
    }

    // MARK: init method

    init() {
        loadBudgetTypes()
    }

    // MARK: Private methods

    private func saveBudgetTypes() {
        if let encoded = try? JSONEncoder().encode(availableTypes) {
            UserDefaults.standard.set(encoded, forKey: BudgetKeys.budgetTypes)
        }
    }
    
    private func loadBudgetTypes() {
        if let savedData = UserDefaults.standard.data(forKey: BudgetKeys.budgetTypes),
           let decoded = try? JSONDecoder().decode([BudgetType].self, from: savedData) {
            availableTypes = decoded
        }
        if availableTypes.isEmpty {
            availableTypes = [
                BudgetType(title: "Groceries", systemImage: "cart.fill"),
                BudgetType(title: "Shopping", systemImage: "bag.fill"),
                BudgetType(title: "Traveling", systemImage: "airplane"),
                BudgetType(title: "Entertainment", systemImage: "film"),
                BudgetType(title: "Miscellaneous", systemImage: "list.bullet.rectangle.fill")
            ]
        }
    }
    
    
    // MARK: Public methods

    func unusedTypes(entries: [BudgetEntry]) -> [BudgetType] {
        let usedTypes = entries.map { $0.type }
        return availableTypes.filter { !usedTypes.contains($0) }
    }
    
    func addBudgetType(title: String, systemImage: String) -> Bool {
        let type = BudgetType(title: title, systemImage: systemImage)
        if availableTypes.count < Constants.maxBudgetTypes {
           availableTypes.append(type)
            return true
        }
        return false
    }
}
