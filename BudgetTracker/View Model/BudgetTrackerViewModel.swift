//
//  BudgetTrackerViewModel.swift
//  BudgetTracker
//
//  Created by shah on 24.9.2024.
//

import Foundation
import SwiftUI

class BudgetTrackerViewModel: ObservableObject {
    // MARK: Variables
    
    @Published var error: Swift.Error?
    @Published var entries: [BudgetEntry] = [] {
        didSet {
            saveEntries()
        }
    }
    @Published var totalBudget: Decimal = 0 {
        didSet {
            saveTotalBudget()
        }
    }
    
    var totalAmount: Decimal {
        entries.reduce(0) { $0 + $1.amount }
    }
    var budgetDatastore = BudgetDatastore.shared
    
    // MARK: Methods
    
    init() {
        loadEntries()
        loadTotalBudget()
    }
}

// MARK: - BudgetEntry

extension BudgetTrackerViewModel {
    // MARK: Public methods
    
    private func validateEntryFields(amountText: String, descriptionText: String, selectedType: BudgetType?) -> BudgetEntry? {
        guard let amount = Utils.decimal(with: amountText), amount > 0 else {
            error = Error.invalidAmount
            return nil
        }
        guard (totalAmount + amount) <= totalBudget else {
            error = Error.outOfBudget
            return nil
        }
        guard descriptionText.count <= Constants.maxDescriptionLength else {
            error = Error.budgetDescriptionTooLong
            return nil
        }
        guard let type = selectedType else {
            error = Error.invalidAmount
            return nil
        }
        let newEntry = BudgetEntry(id: UUID(), amount: amount, description: descriptionText, type: type)
        return newEntry
    }
    
    func addEntry(amountText: String, descriptionText: String, selectedType: BudgetType?, completion: (() -> Void)?) {
        if let newEntry = validateEntryFields(amountText: amountText, descriptionText: descriptionText, selectedType: selectedType){
            entries.append(newEntry)
            completion?()
        }
    }
    
    func updateEntry(entry: BudgetEntry, amountText: String, descriptionText: String, selectedType: BudgetType?, completion: (() -> Void)?){
        guard let newEntry = validateEntryFields(amountText: amountText, descriptionText: descriptionText, selectedType: selectedType) else { return }
        if let index =  entries.firstIndex(where: { $0.id == entry.id }) {
            entries[index].amount = newEntry.amount
            entries[index].description = newEntry.description
            entries[index].type = newEntry.type
            completion?()
        }
    }
    
    func removeEntry(at indexSet: IndexSet) {
        entries.remove(atOffsets: indexSet)
    }
    
    // MARK: Private methods
    
    private func saveEntries() {
        budgetDatastore.saveArrayData(dataArray: entries, key: BudgetKeys.budgetEntries)
    }
    
    private func loadEntries() {
        entries = budgetDatastore.loadArrayData(key: BudgetKeys.budgetEntries)
    }
}

// MARK: - total budget

extension BudgetTrackerViewModel {
    // MARK: Private methods
    
    private func saveTotalBudget() {
        let str = String(describing: totalBudget)
        UserDefaults.standard.set(str, forKey: BudgetKeys.totalBudget)
    }
    
    private func loadTotalBudget() {
        let totalBudgetString = UserDefaults.standard.string(forKey: BudgetKeys.totalBudget) ?? "0"
        totalBudget = Decimal(string: totalBudgetString) ?? 0
    }
    
    // MARK: Public methods
    
    func saveTotalBudget(amountText: String, completion: (() -> Void)?) {
        guard let amount = Utils.decimal(with: amountText), amount > 0 else {
            error = Error.invalidAmount
            return
        }
        guard totalAmount <= amount else {
            error = Error.budgetIsTooLow
            return
        }
        totalBudget = amount
        completion?()
    }
}

// MARK: - Error handling

extension BudgetTrackerViewModel {
    enum Error: LocalizedError {
        case invalidAmount
        case outOfBudget
        case budgetIsTooLow
        case budgetDescriptionTooLong
        
        var errorDescription: String? {
            switch self {
            case .invalidAmount:
                return "Invalid Amount"
            case .outOfBudget:
                return "Out of Budget"
            case .budgetIsTooLow:
                return "Budget is too low"
            case .budgetDescriptionTooLong:
                return "Budget Description Too Long"
            }
        }
        
        var recoverySuggestion: String? {
            switch self {
            case .invalidAmount:
                return "Amount should be number and greater than zero"
            case .outOfBudget:
                return "Amount should be with in budget"
            case .budgetIsTooLow:
                return "More budget is needed or reduce individual budgets"
            case .budgetDescriptionTooLong:
                return "Budget Description should be less than \(Constants.maxDescriptionLength) characters"
            }
        }
    }
}
