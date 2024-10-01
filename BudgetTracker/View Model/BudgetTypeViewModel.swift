//
//  BudgetTypeViewModel.swift
//  BudgetTracker
//
//  Created by shah on 1.10.2024.
//

import Foundation
import SwiftUI

class BudgetTypeViewModel: ObservableObject {
    // MARK: Variables
    
    @Published var error: Swift.Error?

    // MARK: Public methods
    
    func verifyBudgetTypeTitle(_ title: String) -> Bool {
        guard title.count < Constants.maxBudgetTypeTitleLength else {
            error = Error.budgetTypeTitleTooLong
            return false
        }
        return true
    }
    
    func verifyBudgetTypeDoesNotExist(_ title: String, _ availableTypes: [BudgetType]) -> Bool {
        guard availableTypes.contains(where: { $0.title == title }) == false else {
            error = Error.budgetTypeAlreadyExists
            return false
        }
        return true
    }
}

// MARK: - Error handling

extension BudgetTypeViewModel {
    enum Error: LocalizedError {
        case budgetTypeTitleTooLong
        case budgetTypeAlreadyExists
        
        var errorDescription: String? {
            switch self {
            case .budgetTypeTitleTooLong:
                return "Budget Type Title Too Long"
            case .budgetTypeAlreadyExists:
                return "Budget Type Already Exists"
            }
        }
        
        var recoverySuggestion: String? {
            switch self {
            case .budgetTypeTitleTooLong:
                return "Budget Type Title should be less than \(Constants.maxBudgetTypeTitleLength) characters"
            case .budgetTypeAlreadyExists:
                return  "Budget type with same title already exists"
            }
        }
    }
}
