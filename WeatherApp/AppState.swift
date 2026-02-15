//
//  AppState.swift
//  weatherApp
//
//  Created by Konstantin Popov on 07.02.2026.
//

import Foundation
import CoreLocation

enum AppState {
    case retrievingLocation
    case failedToRetrieveLocation
    case retrievingWeather(location: CLLocationCoordinate2D)
    case failedToRetrieveWeather
    case weather(city: String, temperature: Int, iconURL: URL?)
}
