//
//  Dashboard.swift
//  MileageMaster
//
//  Created by Jesse Watson on 09/03/2024.
//

import SwiftUI

struct Dashboard: View {
    
    @EnvironmentObject var mileageMasterData: MileageMasterData
    
    var body: some View {
        
        NavigationView {
            VStack() {
                
                HStack() {
                    
                    Spacer()
                    
                    OpenViewBtn(icon: "plus.circle.fill", text: "New Service") {
                        Loader("testing...")
                    }
                    
                    Spacer()
                    
                    OpenViewBtn(icon: "fuelpump.fill", text: "New Refill", color: Color.orange) {
                        Loader("testing...")
                    }
                    
                    Spacer()
                    
                }
                .padding()
                                
                Text("Upcoming")
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                Text("Recent")
                    .font(.title)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                Text("graphs here...")
                
                Spacer()
                
            }
            .padding()
        }
        .navigationTitle("Dashboard")
    }
}

#Preview {
    Dashboard()
}
