//
//  Account.swift
//  MileageMaster
//
//  Created by Jesse Watson on 12/03/2024.
//

import Foundation

struct Account: Decodable, Identifiable
{
    var id: String = UUID().uuidString
    let name: String
    let email: String
    let cars: [Car]
}
