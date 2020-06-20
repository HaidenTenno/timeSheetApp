//
//  Config.swift
//  timeSheetApp
//
//  Created by Петр Тартынских on 24.03.2020.
//  Copyright © 2020 Петр Тартынских. All rights reserved.
//

import Foundation

enum Config {
    
    enum URLs {
        static let signIn = "http://laratable.educationhost.cloud/api/mobile/auth"
        static func printTabel(tabelNum: Int) -> String { "http://laratable.educationhost.cloud/api/tabels/\(tabelNum)/printed" }
    }
    
    enum UserDefaults {
        static let token = "TimeSheetAppToken"
        static let email = "TimeSheetAppUser"
    }
}
