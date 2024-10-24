//
//  Utils.swift
//  BudgetTracker
//
//  Created by shah on 25.9.2024.
//

import Foundation

class Utils {
    public static var appVersion: String {
        guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
              let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String else {
            return "Unknown"
        }
        return "\(version) (\(build))"
    }
    
    public static func getCurrencyFormatter() -> NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.generatesDecimalNumbers = true
        return numberFormatter
    }
    
    public static func getStringFromDecimal(_ number: Decimal) -> String {
        Utils.getCurrencyFormatter().string(from: number as NSDecimalNumber) ?? ""
    }
    
    public static func decimal(with string: String) -> Decimal? {
        return Decimal(string: string, locale: .current)
    }
}
