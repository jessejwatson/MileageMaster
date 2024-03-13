//
//  Car.swift
//  MileageMaster
//
//  Created by Jesse Watson on 12/03/2024.
//

import Foundation

struct Car: Decodable, Identifiable
{
    var id: String = UUID().uuidString
    let plate: String
    let name: String
    let fuel: String
    let accounts: [Account]
    let entries: [Entry]
}

struct SmallCar: Decodable, Identifiable
{
    var id: String = UUID().uuidString
    let plate: String
    let name: String
    let fuel: String
}
