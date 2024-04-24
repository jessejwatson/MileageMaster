//
//  MileageMasterApp.swift
//  MileageMaster
//
//  Created by Jesse Watson on 09/03/2024.
//

import SwiftUI

@main
struct MileageMasterApp: App {
    var body: some Scene {
        WindowGroup {
            Main()
                .environmentObject(MileageMasterData.shared)
                .onAppear() {
                    let carController = CarController()
                    carController.loadCars()
                    
                    let entryController = EntryController()
                    entryController.loadEntries()
                    
                    let serviceController = ServiceController()
                    serviceController.loadServices()
                }
        }
    }
}

#Preview {
    Main()
}
