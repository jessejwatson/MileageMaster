//
//  File.swift
//  MileageMaster
//
//  Created by Jesse Watson on 26/04/2024.
//

import Foundation
import SwiftUI

class UserDefaultsController {
    
    static let shared = UserDefaultsController()
    
    // --- Account
    
    func cacheAccount(account: Account) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(account) {
            UserDefaults.standard.set(encoded, forKey: "CachedAccount")
        }
    }
    
    func removeAccount() {
        UserDefaults.standard.removeObject(forKey: "CachedAccount")
    }
    
    func loadCachedAccount() -> Account? {
        if let savedAccount = UserDefaults.standard.object(forKey: "CachedAccount") as? Data {
            let decoder = JSONDecoder()
            if let loadedAccount = try? decoder.decode(Account.self, from: savedAccount) {
                return loadedAccount
            }
        }
        return nil
    }
    
    // --- Colors
    
    func cacheAccentColor(accent: Color) {
        let hex = accent.toHex()
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(hex) {
            UserDefaults.standard.set(encoded, forKey: "AccentColor")
        }
    }
    
    func loadCachedAccentColor() -> Color? {
        if let savedAccentColor = UserDefaults.standard.object(forKey: "AccentColor") as? Data {
            let decoder = JSONDecoder()
            if let loadedAccentColorHex = try? decoder.decode(String.self, from: savedAccentColor) {
                return Color(hex: loadedAccentColorHex)
            }
        }
        return nil
    }
    
}
