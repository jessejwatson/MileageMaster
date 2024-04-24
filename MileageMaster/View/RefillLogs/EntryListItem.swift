//
//  EntryView.swift
//  MileageMaster
//
//  Created by Jesse Watson on 15/04/2024.
//

import SwiftUI

struct EntryListItem: View {    
    
    let entry: Entry
    
    init(_ entry: Entry) {
        self.entry = entry
    }
    
    var body: some View {
        NavigationLink(destination: EntryView(entry)) {
            HStack() {
                
                VStack() {
                    
                    Text(entry.car.name)
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("\(entry.liters) liters")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("$\(entry.totalPrice)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
                
                Spacer()
                
            }
            .swipeActions(edge: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/, allowsFullSwipe: false) {
                Button(role: .destructive) {
                    print("delete")
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
        }
    }
}
