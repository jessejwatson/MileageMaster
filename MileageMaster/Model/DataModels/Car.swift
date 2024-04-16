//
//  Car.swift
//  MileageMaster
//
//  Created by Jesse Watson on 12/03/2024.
//

import Foundation

/*
 Will need to learn more about Decodable classes before going any further.
 */

class Car: ObservableObject, Decodable, Identifiable, Equatable
{
    static func == (lhs: Car, rhs: Car) -> Bool {
        lhs.id == rhs.id
    }
    
    var id: String = UUID().uuidString
    var plate: String
    var name: String
    var fuel: String
    var accounts: [SmallAccount]
    var entries: [SmallEntry]
    
    init(id: String, plate: String, name: String, fuel: String, accounts: [SmallAccount], entries: [SmallEntry])
    {
        self.id = id
        self.plate = plate
        self.name = name
        self.fuel = fuel
        self.accounts = accounts
        self.entries = entries
    }
}

struct SmallCar: Decodable, Identifiable
{
    var id: String = UUID().uuidString
    let plate: String
    let name: String
    let fuel: String
}
