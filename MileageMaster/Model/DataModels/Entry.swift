//
//  Entry.swift
//  MileageMaster
//
//  Created by Jesse Watson on 12/03/2024.
//

import Foundation

struct Entry: Codable, Identifiable {
    let id: String
    let date: String
    let createdAt: String
    let odoPrev: Int
    let odoCurr: Int
    let liters: Double
    let totalPrice: Double
    let station: String
    let notes: String?
    let car: SmallCar
}

struct SmallEntry: Codable, Identifiable {
    let id: String
    let date: String
    let createdAt: String
    let odoPrev: Int
    let odoCurr: Int
    let liters: Double
    let totalPrice: Double
    let station: String
    let notes: String?
}

struct Entries: Codable {
    let entries: [Entry]
}

struct CreateEntry: Codable {
    let createEntry: Entry
}

struct DeleteEntry: Codable {
    let deleteEntry: Entry
}

struct DeleteManyEntriesConnection: Codable {
    let deleteManyEntriesConnection: Edges<SmallEntry>
}

struct UpdateEntry: Codable {
    let updateEntry: Entry
}
