//
//  MileageMasterApp.swift
//  MileageMaster
//
//  Created by Jesse Watson on 09/03/2024.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
}

@main
struct MileageMasterApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @State var showSignInView = true
    
    var body: some Scene {
        WindowGroup {
            
            VStack {
                
                if showSignInView == true {
                    
                    AuthView(showSignInView: $showSignInView)
                    
                } else {
                    
                    Main(showSignInView: $showSignInView)
                        .environmentObject(MileageMasterData.shared)
                        .onAppear() {
                            let carController = CarController()
                            carController.loadCars()
                            
                            let entryController = EntryController()
                            entryController.loadEntries()
                            
                            let serviceController = ServiceController()
                            serviceController.loadServices()
                        }
                    
                }
                
            }
            .onAppear() {
                let authController = AuthController()
                showSignInView = !authController.checkAuthentication()
            }
            
        }
    }
}
