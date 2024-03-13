//
//  Main.swift
//  MileageMaster
//
//  Created by Jesse Watson on 09/03/2024.
//

import SwiftUI

struct Main: View
{
    
    func hapticFeedback()
    {
        let generator = UIImpactFeedbackGenerator(style: .light)
            generator.prepare()
            generator.impactOccurred()
    }
    
    var body: some View
    {   
        TabView
        {
            Dashboard()
                .tabItem
                {
                    Label("Dashboard", systemImage: "gauge.open.with.lines.needle.33percent")
                }
                .onAppear
                {
                    hapticFeedback()
                }
            
            ServiceBook()
                .tabItem
                {
                    Label("Service Book", systemImage: "book.pages")
                }
                .onAppear
                {
                    hapticFeedback()
                }
            
            RefillLogs()
                .tabItem
                {
                    Label("Refill Logs", systemImage: "fuelpump")
                }
                .onAppear
                {
                    hapticFeedback()
                }
            
            Settings()
                .tabItem
                {
                    Label("Settings", systemImage: "gear")
                }
                .onAppear
                {
                    hapticFeedback()
                }
        }
    }
}

#Preview {
    Main()
}
