//
//  ProcessViewController.swift
//  weatherApp
//
//  Created by Konstantin Popov on 04.02.2026.
//

import Foundation
import UIKit

class ProcessViewController : UIViewController {
    
    @IBOutlet private weak var messageLabel: UILabel!
    
    var message: String? {
        didSet {
            guard let message = self.message else { return }
            self.messageLabel.text = message
        }
    }
}
