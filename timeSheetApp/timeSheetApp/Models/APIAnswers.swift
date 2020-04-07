//
//  APIAnswers.swift
//  timeSheetApp
//
//  Created by Петр Тартынских on 24.03.2020.
//  Copyright © 2020 Петр Тартынских. All rights reserved.
//

import Foundation

struct AuthAnswer: Codable {
    let access_token: String
    let token_type: String
    let expires_in: Int
}

struct LogoutAnswer: Codable {
    let message: String
}
