//
//  ContentView.swift
//  BudgetTracker
//
//  Created by shah on 23.9.2024.
//

import SwiftUI

struct MainContentView: View {
    @State var totalBudget: Int = 0
    
    var body: some View {
        NavigationSplitView {
            VStack {
                totalBudgetView
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, world!")
                Spacer()
            }
            .padding()
        } detail: {
             Text("Detail view")
        }
        .safeAreaPadding()
    }
    
    private var totalBudgetView: some View {
        ZStack {
            CardView {
                
            } content: {
                VStack {
                    Text("Total Budget: \(totalBudget)")
                        .font(.title)
                }
            }
        }
        .frame(maxHeight: 144)
    }
}

#Preview {
    MainContentView()
}

