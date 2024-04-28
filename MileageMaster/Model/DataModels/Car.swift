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

struct Car: Codable, Identifiable, Hashable {
    static func == (lhs: Car, rhs: Car) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let id: String
    let plate: String
    let name: String
    let fuel: String
    let year: Int
    let serviceIntervalKM: Int
    let serviceIntervalMonth: Int
    let accounts: [Account]
}

struct SmallCar: Codable, Identifiable, Hashable {
    let id: String
    let plate: String
    let name: String
    let fuel: String
    let year: Int
    let serviceIntervalKM: Int
    let serviceIntervalMonth: Int
}

struct Cars: Codable {
    let cars: [Car]
}

struct CreateCar: Codable {
    let createCar: Car
}

struct DeleteCar: Codable {
    let deleteCar: SmallCar
}

struct UpdateCar: Codable {
    let updateCar: SmallCar
}
