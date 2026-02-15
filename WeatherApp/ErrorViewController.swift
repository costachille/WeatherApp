//
//  ErrorViewController.swift
//  weatherApp
//
//  Created by Konstantin Popov on 05.02.2026.
//

import Foundation
import UIKit

class ErrorViewController : UIViewController {
    
    @IBOutlet private weak var messageLabel: UILabel!
    
    var message: String? {
        didSet {
            guard let message = self.message else { return }
            self.messageLabel.text = message
        }
    }
    
    @IBOutlet private weak var actionButton: UIButton!
    
    var actionButtonTitle: String? {
        didSet {
            self.actionButton.setTitle(self.actionButtonTitle, for: [])
        }
    }
    
    @IBAction private func didTapOpenSettingsButton(_ sender: Any) {
        self.didRequestOpenSettings?()
    }
    
    var didRequestOpenSettings: (() -> Void)?
}
