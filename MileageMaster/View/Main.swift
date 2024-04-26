//
//  Main.swift
//  MileageMaster
//
//  Created by Jesse Watson on 09/03/2024.
//

import SwiftUI

struct Main: View {
    
    @Binding var showSignInView: Bool
    
    @EnvironmentObject var mileageMasterData: MileageMasterData
    @ObservedObject var colors = Colors.shared
        
    func hapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
    }
    
    var body: some View {
        
        if mileageMasterData.account == nil || mileageMasterData.cars == nil || mileageMasterData.entries == nil || mileageMasterData.services == nil {
            Loader("Loading data...")
        } else {
            TabView {
                Dashboard()
                    .tabItem {
                        Label("Dashboard", systemImage: "gauge.open.with.lines.needle.33percent")
                    }
                    .onAppear {
                        hapticFeedback()
                    }
                
                ServiceBook()
                    .tabItem {
                        Label("Service Book", systemImage: "book.pages")
                    }
                    .onAppear {
                        hapticFeedback()
                    }
                
                RefillLogs()
                    .tabItem {
                        Label("Refill Logs", systemImage: "fuelpump")
                    }
                    .onAppear {
                        hapticFeedback()
                    }
                
                Settings(showSignInView: $showSignInView)
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
                    .onAppear {
                        hapticFeedback()
                    }
            }
            .tint(colors.accent)
            .background(Colors.shared.background)
        }

    }
}
