//
//  RefillLogs.swift
//  MileageMaster
//
//  Created by Jesse Watson on 09/03/2024.
//

import SwiftUI

struct RefillLogs: View {
    
    @EnvironmentObject var mileageMasterData: MileageMasterData
        
    var body: some View {
        
        if mileageMasterData.cars == nil || mileageMasterData.entries == nil {
            Loader("Loading data...")
        } else {
            NavigationView() {
                List(mileageMasterData.entries!.reversed()) { entry in
                    EntryListItem(entry)
                }
                .navigationTitle("Refill Logs")
            }
        }
    }
}

//#Preview {
//    RefillLogs(logs: $logs)
//}
