//
//  TrainLine.swift
//  KinjalKCTATracker
//
//  Created by kinjal kathiriya  on 4/27/25.
//

import Foundation

struct TrainLine: Codable {
    let name: String
    let color: String
    let stations: [Station]
    
    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case color = "Color"
        case stations = "Stations"
    }
}

struct Station: Codable {
    let name: String
    let stopId: String
    
    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case stopId = "StopId"
    }
}

struct Arrival: Codable {
    let stationName: String
    let destination: String
    let arrivalTime: String
    let isDelayed: Bool
    
    enum CodingKeys: String, CodingKey {
        case stationName = "StationName"
        case destination = "Destination"
        case arrivalTime = "ArrivalTime"
        case isDelayed = "IsDelayed"
    }
}
