//
//  RefillLogs.swift
//  MileageMaster
//
//  Created by Jesse Watson on 09/03/2024.
//

import SwiftUI

struct RefillLogs: View {
    
    // State
    @EnvironmentObject var mileageMasterData: MileageMasterData
    
    // Controllers
    let entryController = EntryController()
    
    // Data
    @State private var carID: String? = nil
    
    // Show
    @State private var showNewRefill = false
    
    var body: some View {
        
        if mileageMasterData.account == nil || mileageMasterData.cars == nil || mileageMasterData.entries == nil || mileageMasterData.services == nil {
            
            Loader("LOADING")
            
        } else {
            NavigationView() {
                VStack {
                    
                    // --- List of Entries
                    
                    List((
                        carID != nil ?
                        mileageMasterData.entries!.reversed().filter({ $0.car.id == carID }) :
                        mileageMasterData.entries!.reversed()
                    )) { entry in
                        EntryListItem(entry)
                    }
                    
                }
                .background(Colors.shared.background)
                .navigationTitle("Refill Logs")
                .toolbar {
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        
                        // --- Car Picker
                        
                        Picker("Select Car", selection: $carID) {
                            Text("All Cars").tag(String?.none)
                            ForEach(mileageMasterData.cars!, id: \.id) { car in
                                Text(car.name).tag(car.id as String?)
                            }
                        }
                        .pickerStyle(.menu)
                        
                        // --- Add Refill Log Button
                        
                        AddButton(showSheet: $showNewRefill)
                        
                    }
                }
            }
            .refreshable {
                entryController.loadEntries()
            }
            .sheet(isPresented: $showNewRefill) {
                
                // --- New Refill Log Sheet
                
                NewRefillLog(preferedCarID: carID)
                    .onDisappear() {
                        showNewRefill = false
                    }
            }
        }
    }
}
