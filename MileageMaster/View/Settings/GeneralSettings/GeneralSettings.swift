//
//  GeneralSettings.swift
//  MileageMaster
//
//  Created by Jesse Watson on 12/03/2024.
//

import SwiftUI

struct GeneralSettings: View {
    
    @State var entries: [Entry]? = nil
    
    var body: some View {
        VStack
        {
            if entries != nil {
                ForEach(entries!, id: \.id) { entry in
                    Text("\(entry.liters)")
                }
            } else {
                Loader("LOADING")
            }
        }
        .navigationTitle("General")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    GeneralSettings()
}
