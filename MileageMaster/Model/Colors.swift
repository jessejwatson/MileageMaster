//
//  Colors.swift
//  MileageMaster
//
//  Created by Jesse Watson on 26/04/2024.
//

import Foundation
import SwiftUI

class Colors: ObservableObject {
    
    static let shared = Colors()
    
    let background = Color.background
    let backgroundSecondary = Color.backgroundSecondary
    let text = Color.text
    let textSecondary = Color.textSecondary
    @Published var accent: Color
    
    init() {
        let accent = UserDefaultsController.shared.loadCachedAccentColor()
        if accent != nil {
            self.accent = accent!
        } else {
            self.accent = Color.accent
        }
    }
    
    func updateAccentColor(_ color: Color) {
        self.accent = color
        UserDefaultsController.shared.cacheAccentColor(accent: color)
    }
    
    func resetAccentColor() {
        self.accent = Color.accent
        UserDefaultsController.shared.cacheAccentColor(accent: Color.accent)
    }
    
}
