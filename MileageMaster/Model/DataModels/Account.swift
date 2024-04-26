//
//  Account.swift
//  MileageMaster
//
//  Created by Jesse Watson on 12/03/2024.
//

import Foundation

struct Account: Codable, Identifiable {
    let id: String
    let email: String
    let name: String
}

struct Accounts: Codable {
    let accounts: [Account]
}

struct AccountResponse: Codable {
    let account: Account
}

struct CreateAccount: Codable {
    let createAccount: Account
}
