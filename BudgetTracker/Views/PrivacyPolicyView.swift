//
//  PrivacyPolicyView.swift
//  BudgetTracker
//
//  Created by Khawar Ali on 25.9.2024.
//

import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        VStack {
            Text("Privacy Policy")
                .font(.largeTitle)
                .padding()
            
            ScrollView {
                Text("Your privacy is important to us. This policy explains how we handle your data.")
                    .padding()
                // Add the rest of your privacy policy here
            }
            .padding()
            
            Spacer()
        }
    }
}
