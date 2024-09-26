//
//  Utils.swift
//  BudgetTracker
//
//  Created by Khawar Ali on 25.9.2024.
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
}
