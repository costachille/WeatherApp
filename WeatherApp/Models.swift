//
//  Models.swift
//  weatherApp
//
//  Created by Konstantin Popov on 08.02.2026.
//

import Foundation

struct LocationModel: Codable {
    var name: String
}

struct CurrentModel: Codable {
    var temp_c: Double
    var condition: ConditionModel
}

struct WeatherResponce: Codable {
    var location: LocationModel
    var current: CurrentModel
}

struct ConditionModel: Codable {
    var text: String
    var ico: String
}
