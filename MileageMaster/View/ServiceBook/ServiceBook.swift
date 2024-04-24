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
                
                List(mileageMasterData.services!) { service in
                    Text("\(service.date)")
                }
                
            }
        } else {
            Text("No services yet!")
        }
        
    }
}

#Preview {
    ServiceBook()
}
