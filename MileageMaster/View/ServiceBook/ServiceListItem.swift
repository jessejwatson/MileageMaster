//
//  ServiceListItem.swift
//  MileageMaster
//
//  Created by Jesse Watson on 15/04/2024.
//

import SwiftUI

struct ServiceListItem: View {
    
    let service: Service
    private let serviceDate: String?
    
    init(_ service: Service) {
        self.service = service
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        if let date = inputFormatter.date(from: service.date) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "EEEE dd/MM/yyyy"
            self.serviceDate = outputFormatter.string(from: date)
        } else {
            print("Error parsing date string")
            self.serviceDate = nil
        }
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
        NavigationLink(destination: ServiceView(service)) {
            
             VStack(alignment: .leading) {
                 
                Text(serviceDate != nil ? String(service.car.name + " on " + serviceDate!) : service.car.name)
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                 HStack {
                     
                     VStack {

                         // --- Odo
                         IconWithValue(systemName: "gauge.open.with.lines.needle.33percent", iconColor: Colors.shared.accent, value: String(service.odo) + " km")

                         // --- Total Price
                         if service.totalPrice != nil {
                             var totalPrice = String(service.totalPrice!)
                             IconWithValue(systemName: "dollarsign.circle.fill", iconColor: Color.green, value: "$" + totalPrice)
                                 .onAppear() {
                                     let numberFormatter = NumberFormatter()
                                     numberFormatter.numberStyle = .decimal
                                     let number = numberFormatter.string(from: NSNumber(value: service.totalPrice!))
                                     if number != nil {
                                         totalPrice = number!
                                     }
                                 }
                         } else {
                             IconWithValue(systemName: "dollarsign.circle.fill", iconColor: Color.green, value: "--")
                         }

                     }

                     VStack {

                         // --- Oil
                         IconWithValue(systemName: "drop.fill", iconColor: Color.orange, value: service.oil ?? "--")

                         // --- Notes
                         IconWithValue(systemName: "list.clipboard.fill", iconColor: Color.orange, value: service.notes ?? "--")

                     }

                 }
                 .padding([.top, .bottom], 4)
                 .swipeActions(edge: .trailing) {

                     // --- Swipe to Delete

                     Button() {
                         showDeleteConfirmation = true
                     } label: {
                         Image(systemName: "trash")
                     }
                     .tint(.red)

                 }
            }
            .alert(isPresented: $showAlert) {

                // --- Alert Popup
                
                Alert(
                    title: Text(alertTitle),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("Dismiss"))
                )
                
            }.confirmationDialog(
                "Are you sure you want to delete this log?",
                isPresented: $showDeleteConfirmation,
                titleVisibility: .visible
            ) {
                
                Button(role: .destructive) {
                    let serviceController = ServiceController()
                    Task {
                        let deletedService: SmallService? = await serviceController.deleteService(id: service.id)
                        if deletedService == nil {
                            showAlert(title: "Unknown Error", message: "There was an error deleting the service. Please try again.")
                        } else {
                            serviceController.loadServices()
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
    
}
