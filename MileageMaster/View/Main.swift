//
//  Main.swift
//  MileageMaster
//
//  Created by Jesse Watson on 09/03/2024.
//

import SwiftUI

struct Main: View
{
    var body: some View
    {   
        TabView
        {
            Dashboard()
                .tabItem
                {
                    Label("Dashboard", systemImage: "gauge.open.with.lines.needle.33percent")
                }
            
            ServiceBook()
                .tabItem
                {
                    Label("Service Book", systemImage: "book.pages")
                }
            
            RefillLogs()
                .tabItem
                {
                    Label("Refill Logs", systemImage: "fuelpump")
                }
            
            Settings()
                .tabItem
                {
                    Label("Settings", systemImage: "gear")
                }

        }
    }
}

#Preview {
    Main()
}
