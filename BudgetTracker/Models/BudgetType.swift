//
//  BudgetType.swift
//  BudgetTracker
//
//  Created by Khawar Ali on 24.9.2024.
//

import SwiftUI

struct BudgetType: Identifiable, Codable, Equatable, Hashable {
    var id = UUID()
    var title: String
    var systemImage: String
    
    static func ==(lhs: BudgetType, rhs: BudgetType) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
