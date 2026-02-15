//
//  ApiClient.swift
//  weatherApp
//
//  Created by Konstantin Popov on 08.02.2026.
//

import Foundation
import CoreLocation
import Alamofire

class ApiClient {
    
    private static let API_KEY = "735dcf37e9a249ba83274550260102"
    
    func fetchWeather(for location: CLLocationCoordinate2D) async -> WeatherResponce? {
        let urlString = "https://api.weatherapi.com/v1/current.json?key=\(Self.API_KEY)&q=\(location.latitude),\(location.longitude)"
        
        do {
            let data = try await AF.request(urlString).serializingData().value
            let decoder = JSONDecoder()
            return try decoder.decode(WeatherResponce.self, from: data)
        } catch {
            return nil
        }
    }
}
