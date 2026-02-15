//
//  WeatherViewController.swift
//  weatherApp
//
//  Created by Konstantin Popov on 01.02.2026.
//

import Foundation
import UIKit

class WeatherViewController: UIViewController {
    

    
    var location: String? {
        didSet {
            guard let location = self.location else { return }
            self.locationLabel.text = location
        }
    }
    
    @IBOutlet private weak var locationLabel: UILabel!
    
    var temperature: Int? {
        didSet {
            guard let temperature = self.temperature else { return }
            self.temperatureLabel.text = "\(temperature)°"
        }
    }
    
    @IBOutlet private weak var temperatureLabel: UILabel!
    
    
    @IBAction func didTapRefreshButton(_ sender: Any) {
        self.didRequestRefresh?()
    }
    
    var didRequestRefresh: (() -> Void)?
}
