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
    
    // Alert
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showAlert = false
    
    // Show
    @State private var showDeleteConfirmation = false
    
    private func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
    
    var body: some View {
        NavigationLink(destination: EntryView(entry)) {
            
            GeometryReader { geometry in
                VStack {
                    
                    Text(entry.car.name)
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack {
                        
                        VStack {
                            
                            // --- Total Price
                            var totalPrice = String(entry.totalPrice)
                            Item(systemName: "dollarsign.circle.fill", iconColor: Color.green, value: totalPrice)
                                .onAppear() {
                                    let numberFormatter = NumberFormatter()
                                    numberFormatter.numberStyle = .decimal
                                    let number = numberFormatter.string(from: NSNumber(value: entry.totalPrice))
                                    if number != nil {
                                        totalPrice = number!
                                    }
                                }
                            
                            // --- Liters
                            Item(systemName: "drop.fill", iconColor: Color.blue, value: String(entry.liters))
                            
                        }
                        .frame(width: geometry.size.width * 0.30)
                        
                        VStack {
                            
                            // --- Station
                            Item(systemName: "mappin.circle.fill", iconColor: Color.red, value: entry.station)
                            
                            // --- Notes
                            var notes = entry.notes ?? "No notes..."
                            Item(systemName: "list.clipboard.fill", iconColor: Color.orange, value: notes)
                                .onAppear() {
                                    if entry.notes != nil {
                                        if entry.notes == "" {
                                            notes = "No notes..."
                                        }
                                    }
                                }
                            
                        }
                        
                    }
                    .swipeActions(edge: .trailing) {
                        
                        // --- Swipe to Delete
                        
                        Button() {
                            showDeleteConfirmation = true
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        .tint(.red)
                        
                    }
                }
            }
            .frame(height: 65, alignment: .leading)
            .alert(isPresented: $showAlert) {
                
                // --- Alert Popup
                
                Alert(
                    title: Text(alertTitle),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("Dismiss"))
                )
                
            }
            .confirmationDialog(
                "Are you sure you want to delete this log?",
                isPresented: $showDeleteConfirmation,
                titleVisibility: .visible
            ) {
                
                // --- Confirmation Dialog
                
                Button(role: .destructive) {
                    let entryController = EntryController()
                    Task {
                        let deletedEntry: Entry? = await entryController.deleteEntry(id: entry.id)
                        if deletedEntry == nil {
                            showAlert(title: "Unknown Error", message: "There was an error deleting the log. Please try again.")
                        } else {
                            let entryController = EntryController()
                            entryController.loadEntries()
                        }
                    }
                } label: {
                    Text("Delete")
                        .foregroundStyle(.red)
                }
                
                Button("Cancel", role: .cancel) {}
                
            }
        }
        .tint(Colors.shared.text)
    }
    
    private struct Item: View {
        
        let systemName: String
        let iconColor: Color
        let value: String
        
        var body: some View {
            HStack {
                Image(systemName: systemName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 15, height: 15)
                    .foregroundStyle(iconColor)
                    .padding([.leading, .trailing], 4)
                    .frame(alignment: .leading)
                Text(value)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        
    }
}
