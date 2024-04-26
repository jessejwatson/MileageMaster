//
//  RefillLogs.swift
//  MileageMaster
//
//  Created by Jesse Watson on 09/03/2024.
//

import SwiftUI

struct RefillLogs: View {
    
    @EnvironmentObject var mileageMasterData: MileageMasterData
    
    @State private var carID: String? = nil
    @State private var entries: [Entry] = []
    
    @State private var showNewRefill = false
    
    func filterEntries() -> [Entry] {
        if mileageMasterData.entries != nil {
            if carID != nil {
                return mileageMasterData.entries!.filter { $0.car.id == carID }
            } else {
                return mileageMasterData.entries!
            }
        } else {
            return []
        }
    }
    
    var body: some View {
        
        if mileageMasterData.account == nil || mileageMasterData.cars == nil || mileageMasterData.entries == nil || mileageMasterData.services == nil {
            
            Loader("LOADING")
            
        } else {
            NavigationView() {
                VStack {
                    
                    // --- List of Entries
                    
                    List(entries.reversed(), id: \.id) { entry in
                        EntryListItem(entry)
                    }
                    
                }
                .background(Color(UIColor.secondarySystemBackground))
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
                        .onChange(of: carID) { newValue, initialValue in
                            entries = filterEntries()
                        }
                        
                        // --- Add Refill Log Button
                        AddButton(showSheet: $showNewRefill)
                        
                    }
                }
            }
            .refreshable {
                let entryController = EntryController()
                entryController.loadEntries()
                
                entries = filterEntries()
            }
            .onAppear() {
                if mileageMasterData.entries != nil {
                    if carID != nil {
                        entries = mileageMasterData.entries!.filter({ $0.car.id == carID })
                    } else {
                        entries = mileageMasterData.entries!
                    }
                }
            }
            .sheet(isPresented: $showNewRefill) {
                NewRefillLog(preferedCarID: carID)
                    .onDisappear() {
                        showNewRefill = false
                    }
            }
        }
    }
}
