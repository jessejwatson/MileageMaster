//
//  Main.swift
//  MileageMaster
//
//  Created by Jesse Watson on 09/03/2024.
//

import SwiftUI

struct Main: View {
    
    @Binding var showSignInView: Bool
    
    @EnvironmentObject var mileageMasterData: MileageMasterData
    @ObservedObject var colors = Colors.shared
    
    @StateObject private var networkMonitor = NetworkMonitor()
    @State private var showNoConnection = false
    
    var body: some View {
        
        if mileageMasterData.account == nil || mileageMasterData.cars == nil || mileageMasterData.entries == nil || mileageMasterData.services == nil {
            Loader("Loading data...")
        } else {
            ZStack {
                
                TabView {
                    Dashboard()
                        .tabItem {
                            Label("Dashboard", systemImage: "gauge.open.with.lines.needle.33percent")
                        }
                        .onAppear {
                            Haptics.shared.haptic(.light)
                        }
                    
                    ServiceBook()
                        .tabItem {
                            Label("Service Book", systemImage: "book.pages")
                        }
                        .onAppear {
                            Haptics.shared.haptic(.light)
                        }
                    
                    RefillLogs()
                        .tabItem {
                            Label("Refill Logs", systemImage: "fuelpump")
                        }
                        .onAppear {
                            Haptics.shared.haptic(.light)
                        }
                    
                    Settings(showSignInView: $showSignInView)
                        .tabItem {
                            Label("Settings", systemImage: "gear")
                        }
                        .onAppear {
                            Haptics.shared.haptic(.light)
                        }
                }
                .tint(colors.accent)
                .background(Colors.shared.background)
                
                VStack {
                    Spacer()
                    
                    if showNoConnection {
                        NoNetworkView()
                            .transition(.move(edge: .top).combined(with: .opacity))
                            .animation(.easeInOut, value: showNoConnection)
                            .padding(.bottom, 60)
                    }
                }
                
            }
            .onChange(of: networkMonitor.isConnected) { _, _ in
                withAnimation(.easeInOut(duration: 0.5)) {
                    showNoConnection = !networkMonitor.isConnected
                }
            }
        }
        
    }
}
