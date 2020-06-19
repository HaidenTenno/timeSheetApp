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
    
    var email: String? {
        get {
            return string(forKey: Config.UserDefaults.email)
        }
        set {
            set(newValue, forKey: Config.UserDefaults.email)
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
