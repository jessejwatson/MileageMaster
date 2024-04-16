//
//  EntryView.swift
//  MileageMaster
//
//  Created by Jesse Watson on 15/04/2024.
//

import SwiftUI

struct EntryView: View {
    
    let entry: Entry
    
    init(_ entry: Entry) {
        self.entry = entry
    }
    
    var body: some View {
        NavigationView() {
            VStack() {
                
                Text("$\(entry.totalPrice)")
                Text("Station: \(entry.station)")
                
            }
        }
        .navigationTitle("Log")
    }
}
