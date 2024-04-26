//
//  ServiceBook.swift
//  MileageMaster
//
//  Created by Jesse Watson on 09/03/2024.
//

import SwiftUI

struct ServiceBook: View {
    
    @EnvironmentObject var mileageMasterData: MileageMasterData
    
    var body: some View {
        
        if mileageMasterData.services != nil {
            NavigationView {
                
                if mileageMasterData.account == nil || mileageMasterData.cars == nil || mileageMasterData.entries == nil || mileageMasterData.services == nil {
                    
                    Loader("LOADING")
                    
                } else {
                    
                    List(mileageMasterData.services!) { service in
                        Text("\(service.date)")
                    }
                    
                }
                
            }
            .refreshable {
                let serviceController = ServiceController()
                serviceController.loadServices()
            }
        } else {
            Text("No services yet!")
        }
        
    }
}

#Preview {
    ServiceBook()
}
