//
//  File.swift
//  MileageMaster
//
//  Created by Jesse Watson on 18/04/2024.
//

import Foundation

struct Service: Codable, Identifiable {
    let id: String
    let createdAt: String
    let date: String
    let totalPrice: Double?
    let oil: String?
    let notes: String?
    let car: SmallCar
}

struct SmallService: Codable, Identifiable {
    let id: String
    let createAt: String
    let date: String
    let totalPrice: Double?
    let oil: String?
    let notes: String?
}

struct Services: Codable {
    let services: [Service]
}

struct DeleteService: Codable {
    let deleteService: SmallService
}

struct DeleteManyServicesConnection: Codable {
    let deleteManyServicesConnection: Edges<SmallService>
}
