//
//  Settings.swift
//  MileageMaster
//
//  Created by Jesse Watson on 09/03/2024.
//

import SwiftUI

struct Settings: View {
    
    @Binding var showSignInView: Bool
    @EnvironmentObject var mileageMasterData: MileageMasterData
    
    // Alert
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showAlert = false
    
    @State private var accentColor = Colors.shared.accent
    
    private func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
        
    var body: some View {
        
        if mileageMasterData.account == nil || mileageMasterData.cars == nil || mileageMasterData.entries == nil || mileageMasterData.services == nil {
            
            Loader("LOADING")
            
        } else {
            NavigationView {
                VStack {
                    
                    List {
                        
                        // --- My Cars
                        
                        NavigationLink("My Cars", destination: MyCars())
                        
                        // --- Accent Color
                        
                        HStack {
                            
                            Text("Accent Color")
                            
                            Spacer()
                            
                            Button("Reset") {
                                Colors.shared.resetAccentColor()
                            }
                            .foregroundStyle(.accent)
                            
                            ColorPicker("", selection: $accentColor)
                                .frame(maxWidth: 30)
                                .onChange(of: accentColor) { color, initial in
                                    Colors.shared.updateAccentColor(color)
                                }
                            
                        }
                        
                        Section {
                            
                            // --- Log Out Button
                            
                            Button {
                                let authController = AuthController()
                                do {
                                    try authController.signOut()
                                    showSignInView = true
                                } catch {
                                    showAlert(title: "Error!", message: "There was an error signing out. Please try again.")
                                }
                            } label: {
                                Text("Log Out")
                                    .foregroundStyle(.red)
                            }
                            
                        }
                        
                    }
                    
                }
                .navigationTitle("Settings")
                .alert(isPresented: $showAlert) {
                    
                    // --- Alert Popup
                    
                    Alert(
                        title: Text(alertTitle),
                        message: Text(alertMessage),
                        dismissButton: .default(Text("Dismiss"))
                    )
                    
                }
            }
            .background(Colors.shared.background)
        }

    }
}

//#Preview {
//    Settings()
//}
