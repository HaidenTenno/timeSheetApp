//
//  NetworkService.swift
//  timeSheetApp
//
//  Created by Петр Тартынских on 24.03.2020.
//  Copyright © 2020 Петр Тартынских. All rights reserved.
//

import Foundation
import Alamofire

enum NetworkServiceError {
    case connectionError
    case receiveDataError(_ error: Error)
}

protocol NetworkServiceDelegate: class {
    func networkServiceDidSignIn(_ networkService: NetworkService)
    func networkServiceDidLogout(_ networkService: NetworkService)
    func networkService(_ networkService: NetworkService, failedWith error: NetworkServiceError)
}

extension NetworkServiceDelegate {
    
    func networkServiceDidSignIn(_ networkService: NetworkService) {
        #if DEBUG
        print("NETWORK SERVICE SIGNED IN")
        #endif
    }
    
    func networkServiceDidLogout(_ networkService: NetworkService) {
        #if DEBUG
        print("NETWORK SERVICE LOGGED OUT")
        #endif
    }
    
    func networkService(_ networkService: NetworkService, failedWith error: NetworkServiceError) {
        #if DEBUG
        print("NETWORK SERVICE FAILED WITH ERROR: \(error)")
        #endif
    }
}

protocol NetworkService {
    var delegate: NetworkServiceDelegate? { get set }
    func signIn(login: String, password: String)
    func logout()
}

final class NetworkServiceImplementation {
    
    static let shared = NetworkServiceImplementation()
    
    private let sessionManager = Alamofire.Session.default
    
    private var isConnectedToInternet: Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
    
    weak var delegate: NetworkServiceDelegate?
    
    private init() {}
}

// MARK: NetworkService
extension NetworkServiceImplementation: NetworkService {
    
    func signIn(login: String, password: String) {
        
        guard isConnectedToInternet else {
            delegate?.networkService(self, failedWith: .connectionError)
            return
        }
        
        //guard let url = URL(string: Config.URLs.signIn) else { return }
        
        // TODO: Change to normal request when server side will be implemented
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let strongSelf = self else { return }
            Thread.sleep(forTimeInterval: 1)
            strongSelf.delegate?.networkServiceDidSignIn(strongSelf)
        }
    }
    
    func logout() {
        
        guard isConnectedToInternet else {
            delegate?.networkService(self, failedWith: .connectionError)
            return
        }
        
        //guard let url = URL(string: Config.URLs.signIn) else { return }
                
        // TODO: Change to normal request when server side will be implemented
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let strongSelf = self else { return }
            Thread.sleep(forTimeInterval: 1)
            strongSelf.delegate?.networkServiceDidLogout(strongSelf)
        }
    }
}
