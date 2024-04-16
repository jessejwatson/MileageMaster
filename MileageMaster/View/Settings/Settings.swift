//
//  Settings.swift
//  MileageMaster
//
//  Created by Jesse Watson on 09/03/2024.
//

import SwiftUI

struct Settings: View {
    
    @EnvironmentObject var mileageMasterData: MileageMasterData
        
    var body: some View {
        
        if mileageMasterData.cars == nil || mileageMasterData.entries == nil {
            
        } else {
            NavigationView {
                List {
                    NavigationLink("General", destination: GeneralSettings())
                    NavigationLink("My Cars", destination: MyCars(cars: mileageMasterData.cars!))
                }
                .navigationTitle("Settings")
            }
        }

    }
}

//#Preview {
//    Settings()
//}
