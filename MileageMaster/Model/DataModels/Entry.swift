//
//  Entry.swift
//  MileageMaster
//
//  Created by Jesse Watson on 12/03/2024.
//

import Foundation

struct Entry: Decodable, Identifiable
{
    var id: String = UUID().uuidString
    let createdAt: String
    let odoPrev: Int
    let odoCurr: Int
    let liters: Double
    let totalPrice: Double
    let station: String
    let notes: String?
    let car: Car
}

struct SmallEntry: Decodable, Identifiable
{
    var id: String = UUID().uuidString
    let createdAt: String
    let odoPrev: Int
    let odoCurr: Int
    let liters: Double
    let totalPrice: Double
    let station: String
    let notes: String?
}
