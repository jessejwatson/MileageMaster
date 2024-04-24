//
//  Account.swift
//  MileageMaster
//
//  Created by Jesse Watson on 12/03/2024.
//

import Foundation

struct Account: Codable, Identifiable {
    let id: String
    let name: String
    let email: String
    let cars: [SmallCar]
}

struct SmallAccount: Codable, Identifiable {
    let id: String
    let name: String
    let email: String
}

struct Accounts: Codable {
    let accounts: [Account]
}
