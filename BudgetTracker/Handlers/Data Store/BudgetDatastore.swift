//
//  BudgetDatastore.swift
//  BudgetTracker
//
//  Created by shah on 1.10.2024.
//

import Foundation
import SwiftUI

struct BudgetKeys {
    static let budgetEntries = "budgetEntries"
    static let budgetTypes = "budgetTypes"
    static let totalBudget = "totalBudget"
    static let appTheme = "appTheme"
}

class BudgetDatastore: ObservableObject {
    
    static let shared = BudgetDatastore()
    
    func loadData<T: Codable>(key: String) -> T? {
        if let savedData = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode(T.self, from: savedData) {
            return decoded
        } else {
            return nil
        }
    }

    func saveArrayData<T: Codable>(dataArray: [T], key: String) {
        if let encoded = try? JSONEncoder().encode(dataArray) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }
    
    func loadArrayData<T: Codable>(key: String) ->  [T]{
        if let savedData = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([T].self, from: savedData) {
            return decoded
        } else {
            return []
        }
    }
}
