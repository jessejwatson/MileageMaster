//
//  NetworkConnection.swift
//  MileageMaster
//
//  Created by Jesse Watson on 5/7/2024.
//

import Foundation

import SwiftUI
import Network
class NetworkMonitor: ObservableObject {
    @Published var isConnected: Bool = true
    private var monitor: NWPathMonitor
    private var queue: DispatchQueue

    init() {
        self.monitor = NWPathMonitor()
        self.queue = DispatchQueue.global(qos: .background)
        self.monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = (path.status == .satisfied)
            }
        }
        self.monitor.start(queue: self.queue)
    }
}
