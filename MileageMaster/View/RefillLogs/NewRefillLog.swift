//
//  NewRefillLog.swift
//  MileageMaster
//
//  Created by Jesse Watson on 19/04/2024.
//

import SwiftUI

struct NewRefillLog: View {
    
    @EnvironmentObject var mileageMasterData: MileageMasterData
    
    @State private var carID: String? = nil
    @State private var odoCurr: Int? = nil
    @State private var odoPrev: Int? = nil
    @State private var liters: Double? = nil
    @State private var totalPrice: Double? = nil
    @State private var station: String = ""
    @State private var notes: String = ""
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showAlert = false
    @State private var showSuccess = false
    
    @State private var successOpacity = 0.0
    
    public struct TextArea: TextFieldStyle {
        public func _body(configuration: TextField<Self._Label>) -> some View {
            configuration
                .padding([.top, .bottom], 50)
                .padding([.leading, .trailing], 5)
                .background(
                    RoundedRectangle(cornerRadius: 5)
                        .strokeBorder(Color.primary.opacity(0.1))
                )
        }
    }
    
    private func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
    
    var body: some View {
        
        VStack {
            
            // change to false
            if showSuccess == true {
                
                if mileageMasterData.cars != nil ||
                    mileageMasterData.cars?.count != 0 {
                    
                    Text("New Refill Log")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Picker("Select Car", selection: $carID) {
                        Text("None").tag(String?.none)
                        ForEach(mileageMasterData.cars!, id: \.id) { car in
                            Text(car.name).tag(car.id as String?)
                        }
                    }
                    .pickerStyle(.menu)
                    
                    TextField("Previous Odo", value: $odoPrev, format: .number)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 300)
                    
                    TextField("Current Odo", value: $odoCurr, format: .number)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 300)
                    
                    TextField("Liters", value: $liters, format: .number)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 300)
                    
                    TextField("Total Price", value: $totalPrice, format: .currency(code: "$"))
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 300)
                    
                    TextField("Station", text: $station)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 300)
                    
                    TextField("Notes", text: $notes)
                        .textFieldStyle(TextArea())
                        .frame(width: 300)
                    
                    Button() {
                        // not getting alert when second requirement isn't met
                        
                        print("clicked button")
                        
                        if  odoCurr != nil &&
                                odoPrev != nil &&
                                liters != nil &&
                                totalPrice != nil &&
                                carID != nil
                        {
                            print("meets first requirements")
                            
                            if odoCurr! < odoPrev! {
                                showAlert(title: "That Odometer Isn't Right!", message: "The current odometer reading cannot be less than the previous odometer reading.")
                            } else {
                                print("meets second requirements")
                                
                                let entryController = EntryController()
                                Task {
                                    let createdEntry: Entry? = await entryController.createEntry(odoCurr: odoCurr!, odoPrev: odoPrev!, liters: liters!, totalPrice: totalPrice!, station: station, notes: notes, carID: carID!)
                                    print(createdEntry ?? "nil")
                                    if createdEntry == nil {
                                        showAlert(title: "Unknown Error", message: "There was an error. Please try again.")
                                    } else {
                                        let entryController = EntryController()
                                        entryController.loadEntries()
                                        showSuccess = true
                                    }
                                }
                            }
                        } else {
                            showAlert(title: "You're Not Done!", message: "Please fill out the required fields.")
                        }
                    } label: {
                        Text("Create")
                    }
                    .padding()
                    .background(Color.accentColor)
                    .foregroundStyle(.white)
                    .cornerRadius(8)
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text(alertTitle),
                            message: Text(alertMessage),
                            dismissButton: .default(Text("Dismiss"))
                        )
                    }
                    
                    Spacer()
                    
                } else {
                    Text("No cars. Please add a car in settings first.")
                }
                
            } else {
                VStack {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundStyle(Color.accentColor.opacity(successOpacity * 0.7))
                        .padding(.bottom)
                    Text("Refill Log Creation Successful!")
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                        .opacity(successOpacity)
                }
                .onAppear() {
                    withAnimation(.easeIn(duration: 1)) {
                        successOpacity = 1.0
                    }
                }
            }
            
        }
        .padding()
        .onAppear() {
            if carID == nil, let firstCarID = mileageMasterData.cars?.first?.id {
                carID = firstCarID
            }
            
            if let lastEntry = mileageMasterData.entries?.last {
                odoPrev = lastEntry.odoCurr
            }
        }
        
    }
}
