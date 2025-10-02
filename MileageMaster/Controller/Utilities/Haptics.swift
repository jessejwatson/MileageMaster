//
//  Haptics.swift
//  MileageMaster
//
//  Created by Jesse Watson on 15/7/2024.
//

import Foundation
import UIKit

class Haptics {
    
    static let shared = Haptics()
    
    func haptic(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }
    
    func success() {
        // First tap
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.success)
        
        // Delay for the second tap, in milliseconds (200ms for example)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            generator.prepare()
            generator.notificationOccurred(.success)
        }
    }
    
    func error() {
        // First tap
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.error)
        
        // Delay for the second tap, in milliseconds (200ms for example)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            generator.prepare()
            generator.notificationOccurred(.error)
        }
    }
    
    func warning() {
        // First tap
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.warning)
        
        // Delay for the second tap, in milliseconds (200ms for example)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            generator.prepare()
            generator.notificationOccurred(.warning)
        }
    }
    
}
