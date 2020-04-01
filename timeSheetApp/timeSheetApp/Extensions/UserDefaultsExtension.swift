//
//  UserDefaultsExtension.swift
//  timeSheetApp
//
//  Created by Петр Тартынских on 02.04.2020.
//  Copyright © 2020 Петр Тартынских. All rights reserved.
//

import Foundation

import Foundation

extension UserDefaults {
    
    var user: String? {
        get {
            return string(forKey: Config.UserDefaults.user)
        }
        set {
            set(newValue, forKey: Config.UserDefaults.user)
        }
    }
    
    var token: String? {
        get {
            return string(forKey: Config.UserDefaults.token)
        }
        set {
            set(newValue, forKey: Config.UserDefaults.token)
        }
    }
}
