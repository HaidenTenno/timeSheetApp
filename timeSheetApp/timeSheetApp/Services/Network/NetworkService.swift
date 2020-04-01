//
//  NetworkService.swift
//  timeSheetApp
//
//  Created by Петр Тартынских on 24.03.2020.
//  Copyright © 2020 Петр Тартынских. All rights reserved.
//

import Foundation
import Alamofire

protocol NetworkService {
    func signIn(login: String, password: String)
    func logout()
}

final class NetworkServiceImplementation {
    
    static let shared = NetworkServiceImplementation()
    
    private let sessionManager = Alamofire.Session.default
    
    private var isConnectedToInternet: Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    private init() {}
}

// MARK: NetworkService
extension NetworkServiceImplementation: NetworkService {
    
    func signIn(login: String, password: String) {
        
    }
    
    func logout() {
        
    }
}
