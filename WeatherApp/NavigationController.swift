import Foundation
import UIKit
import SwiftLocation
import CoreLocation

class NavigationController: UINavigationController {
    
    var appState: AppState? {
        didSet {
            guard let appState = self.appState else { return }
            
            switch appState {
                
            case .retrievingLocation:
                self.showProcessScreen(withMessage: "Определяем ваше местоположение...")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    
                    Task {
                        let userLocation = await self.retrieveLocation()
                        
                        DispatchQueue.main.async {
                            if let userLocation = userLocation {
                                self.appState = .retrievingWeather(location: userLocation)
                            } else {
                                self.appState = .failedToRetrieveLocation
                            }
                        }
                    }
                }
                
            case .failedToRetrieveLocation:
                self.showError(withMessage: "Не удалось определить ваше местоположение", actionButtonTitle: "Открыть настройки") {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                }
                
            case .retrievingWeather(let location):
                self.showProcessScreen(withMessage: "Уточняем погоду для вашей локации...")
                
                Task {
                    let weather = await ApiClient().fetchWeather(for: location)
                    
                    DispatchQueue.main.async {
                        if let weather = weather {
                            self.appState = .weather(
                                city: weather.location.name,
                                temperature: Int(weather.current.temp_c),
                                iconURL: weather.current.condition.iconURL)
                        } else {
                            self.appState = .failedToRetrieveWeather
                        }
                    }
                }
                
            case .failedToRetrieveWeather:
                self.showError(withMessage: "Не удалось связаться с сервером", actionButtonTitle: "Попробовать еще раз") {
                    self.appState = .retrievingLocation
                }
                
            case .weather(let city, let temperature, let iconURL):
                self.showWeather(
                    withTemperature: temperature,
                    forLocation: city,
                    iconURL: iconURL
                ) {
                    self.appState = .retrievingLocation
                }
            }
        }
    }
    
    private let location = Location()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.appState = .retrievingLocation
    }
    
    func showWeather(
        withTemperature temperature: Int,
        forLocation location: String,
        iconURL: URL?,
        onRequestedRefresh: @escaping () -> Void
    ) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "WeatherViewController") as? WeatherViewController else {
            return
        }
        let _ = vc.view
        vc.location = location
        vc.iconURL = iconURL
        vc.temperature = temperature
        vc.didRequestRefresh = onRequestedRefresh
        self.viewControllers = [vc]
    }
    
    func showProcessScreen(withMessage message: String) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProcessViewController") as? ProcessViewController else {
            return
        }
        let _ = vc.view
        vc.message = message
        self.viewControllers = [vc]
    }
    
    func showError(withMessage message: String, actionButtonTitle: String, onTappedActionButton: @escaping () -> Void) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ErrorViewController") as? ErrorViewController else {
            return
        }
        let _ = vc.view
        vc.message = message
        vc.actionButtonTitle = actionButtonTitle
        vc.didRequestOpenSettings = onTappedActionButton
        self.viewControllers = [vc]
    }
    
    private func retrieveLocation() async -> CLLocationCoordinate2D? {
        do {
            try await self.location.requestPermission(.whenInUse)
            let result = try await self.location.requestLocation().location?.coordinate
            return result
        } catch {
            return nil
        }
    }
}
