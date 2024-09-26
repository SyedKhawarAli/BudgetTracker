//
//  BudgetTrackerViewModel.swift
//  BudgetTracker
//
//  Created by shah on 24.9.2024.
//

import Foundation
import SwiftUI

class BudgetTrackerViewModel: ObservableObject {
    private struct BudgetKeys {
        static let budgetEntries = "budgetEntries"
        static let budgetTypes = "budgetTypes"
        static let totalBudget = "totalBudget"
    }
    
    // MARK: Variables
    
    private let maxTypes = 15
    @Published var error: Swift.Error?
    @Published var entries: [BudgetEntry] = [] {
        didSet {
            saveEntries()
        }
    }
    @Published var totalBudget: Double = 0 {
        didSet {
            saveTotalBudget()
        }
    }
    @Published var availableTypes: [BudgetType] = []{
        didSet {
            saveBudgetTypes()
        }
    }
    var unusedTypes: [BudgetType] {
        let usedTypes = entries.map { $0.type }
        return availableTypes.filter { !usedTypes.contains($0) }
    }
    var totalAmount: Double {
        entries.reduce(0) { $0 + $1.amount }
    }
    
    // MARK: Methods
    
    init() {
        loadEntries()
        loadBudgetTypes()
        loadTotalBudget()
    }
}

// MARK: - BudgetEntry

extension BudgetTrackerViewModel {
    // MARK: Public methods
    
    func addEntry(amountText: String, descriptionText: String, selectedType: BudgetType?, completion: (() -> Void)?) {
        guard let amount = Double(amountText), amount > 0 else {
            error = Error.invalidAmount
            return
        }
        guard descriptionText.count <= Constants.maxDescriptionLength else {
            error = Error.budgetDescriptionTooLong
            return
        }
        guard let type = selectedType else {
            error = Error.invalidAmount
            return
        }
        let newEntry = BudgetEntry(id: UUID(), amount: amount, description: descriptionText, type: type)
        entries.append(newEntry)
        completion?()
    }
    
    func updateEntry(entry: BudgetEntry, amountText: String, descriptionText: String, selectedType: BudgetType?, completion: (() -> Void)?){
        guard let amount = Double(amountText), amount > 0 else {
            error = Error.invalidAmount
            return
        }
        guard let type = selectedType else {
            error = Error.invalidAmount
            return
        }
        if let index =  entries.firstIndex(where: { $0.id == entry.id }) {
            entries[index].amount = amount
            entries[index].description = descriptionText
            entries[index].type = type
            completion?()
        }
    }
    
    func removeEntry(at indexSet: IndexSet) {
        entries.remove(atOffsets: indexSet)
    }
    
    // MARK: Private methods
    
    private func saveEntries() {
        if let encoded = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(encoded, forKey: BudgetKeys.budgetEntries)
        }
    }
    
    private func loadEntries() {
        if let savedData = UserDefaults.standard.data(forKey: BudgetKeys.budgetEntries),
           let decoded = try? JSONDecoder().decode([BudgetEntry].self, from: savedData) {
            entries = decoded
        }
    }
}

// MARK: - BudgetTypes

extension BudgetTrackerViewModel {
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
    
    func addBudgetType(title: String, systemImage: String) -> Bool {
        guard title.count < Constants.maxBudgetTypeTitleLength else {
            error = Error.budgetTypeTitleTooLong
            return false
        }
        guard availableTypes.contains(where: { $0.title == title }) == false else {
            error = Error.budgetTypeAlreadyExists
            return false
        }
        let type = BudgetType(title: title, systemImage: systemImage)
        if availableTypes.count < maxTypes {
            availableTypes.append(type)
            return true
        }
        return false
    }
}

// MARK: - total budget

extension BudgetTrackerViewModel {
    // MARK: Private methods
    
    private func saveTotalBudget() {
        UserDefaults.standard.set(totalBudget, forKey: BudgetKeys.totalBudget)
    }
    
    private func loadTotalBudget() {
        totalBudget = UserDefaults.standard.double(forKey: BudgetKeys.totalBudget)
    }
    
    // MARK: Public methods
    
    func saveTotalBudget(amountText: String, completion: (() -> Void)?) {
        guard let amount = Double(amountText), amount > 0 else {
            error = Error.invalidAmount
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
        case budgetDescriptionTooLong
        case budgetTypeNotFound
        case budgetTypeTitleTooLong
        case budgetTypeAlreadyExists
        
        var errorDescription: String? {
            switch self {
            case .invalidAmount:
                return "Invalid Amount"
            case .budgetTypeNotFound:
                return "Budget Type Not Found"
            case .budgetTypeTitleTooLong:
                return "Budget Type Title Too Long"
            case .budgetDescriptionTooLong:
                return "Budget Description Too Long"
            case .budgetTypeAlreadyExists:
                return "Budget Type Already Exists"
            }
        }
        
        var recoverySuggestion: String? {
            switch self {
            case .invalidAmount:
                return "Amount should be number and greater than zero"
            case .budgetTypeNotFound:
                return "select a budget type"
            case .budgetTypeTitleTooLong:
                return "Budget Type Title should be less than \(Constants.maxBudgetTypeTitleLength) characters"
            case .budgetDescriptionTooLong:
                return "Budget Description should be less than \(Constants.maxDescriptionLength) characters"
            case .budgetTypeAlreadyExists:
                return  "Budget type with same title already exists"
            }
        }
    }
}
