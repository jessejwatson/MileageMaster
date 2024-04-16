//
//  MileageMasterData.swift
//  MileageMaster
//
//  Created by Jesse Watson on 15/04/2024.
//

import Foundation

class MileageMasterData: ObservableObject {
    
    @Published var cars: [Car]?
    @Published var entries: [Entry]?
    @Published var account: Account?
    
    static let shared = MileageMasterData()
    
    private init() {}
    
}
