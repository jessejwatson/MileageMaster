//
//  RefillLogs.swift
//  MileageMaster
//
//  Created by Jesse Watson on 09/03/2024.
//

import SwiftUI

struct ServiceBook: View {
    
    // State
    @EnvironmentObject var mileageMasterData: MileageMasterData
    
    // Controllers
    let serviceController = ServiceController()
    
    // Data
    @State private var carID: String? = nil
    
    // Show
    @State private var showNewService = false
    
    var body: some View {
        
        if mileageMasterData.account == nil || mileageMasterData.cars == nil || mileageMasterData.entries == nil || mileageMasterData.services == nil {
            
            Loader("LOADING")
            
        } else {
            NavigationView() {
                VStack {
                    
                    // --- List of Services
                    
                    List((
                        carID != nil ?
                        mileageMasterData.services!.reversed().filter({ $0.car.id == carID }) :
                        mileageMasterData.services!.reversed()
                    )) { service in
                        ServiceListItem(service)
                    }
                    
                }
                .background(Colors.shared.background)
                .navigationTitle("Service Book")
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
                        
                        // --- Add Service Button
                        
                        AddButton(showSheet: $showNewService)
                        
                    }
                }
            }
            .refreshable {
                serviceController.loadServices()
            }
            .sheet(isPresented: $showNewService) {
                
                // --- New Service Sheet
                
                NewService(preferedCarID: carID)
                    .onDisappear() {
                        showNewService = false
                    }
            }
        }
    }
}
