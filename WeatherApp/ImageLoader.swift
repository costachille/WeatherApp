//
//  ImageLoader.swift
//  weatherApp
//
//  Created by Konstantin Popov on 15.02.2026.
//

import Foundation
import UIKit

final class ImageLoader {
    
    static let shared = ImageLoader()
    
    private init() {}
    
    func loadImage(from url: URL) async -> UIImage? {
        
        do {
            
            let (data, _) = try await URLSession.shared.data(from: url)
            
            return UIImage(data: data)
            
        } catch {
            
            print("Failed to load image:", error)
            return nil
        }
    }
}
