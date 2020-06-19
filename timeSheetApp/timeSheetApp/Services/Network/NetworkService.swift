//
//  NetworkService.swift
//  timeSheetApp
//
//  Created by Петр Тартынских on 24.03.2020.
//  Copyright © 2020 Петр Тартынских. All rights reserved.
//

import Foundation
import Alamofire

enum NetworkServiceError: Error {
    case connectionError
    case unauthorizedError
    case receiveDataError(_ error: Error?)
}

protocol NetworkServiceDelegate: class {
    func networkServiceDidSignIn(_ networkService: NetworkService)
    func networkServiceDidPrintTabel(_ networkService: NetworkService)
    func networkServiceDidLogout(_ networkService: NetworkService)
    func networkService(_ networkService: NetworkService, failedWith error: NetworkServiceError)
}

extension NetworkServiceDelegate {
    
    func networkServiceDidSignIn(_ networkService: NetworkService) {
        #if DEBUG
        print("NETWORK SERVICE SIGNED IN")
        #endif
    }
    
    func networkServiceDidPrintTabel(_ networkService: NetworkService) {
        #if DEBUG
        print("NETWORK SERVICE PRINTED TABEL")
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
    func signIn(email: String, password: String)
    func printTabel(token: String, tabelNum: Int)
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
    
    func signIn(email: String, password: String) {
        
        guard isConnectedToInternet else {
            delegate?.networkService(self, failedWith: .connectionError)
            return
        }
        
        guard let url = URL(string: Config.URLs.signIn) else { return }
        
        AF.request(url, method: .post, parameters: [
            "username": email,
            "password": password
        ]).validate().response { [weak self] response in
            
            guard let strongSelf = self else { return }
            
            switch response.result {
            case .success(let data):
                guard let data = data else {
                    strongSelf.delegate?.networkService(strongSelf, failedWith: .receiveDataError(nil))
                    return
                }
                do {
                    let parsedResponse = try JSONDecoder().decode(AuthAnswer.self, from: data)
                    print(parsedResponse.accessToken)
                    strongSelf.delegate?.networkServiceDidSignIn(strongSelf)
                    
                    // TODO: Rewrite UserDefaults
//                    strongSelf.userDefaults.token = parsedResponse.access_token
//                    strongSelf.userDefaults.user = email
//                    strongSelf.delegate?.networkServiceDidLoggedIn(strongSelf, user: email)
                }
                catch {
                    strongSelf.delegate?.networkService(strongSelf, failedWith: .receiveDataError(nil))
                    return
                }
            case .failure(let error):
                strongSelf.delegate?.networkService(strongSelf, failedWith: .receiveDataError(error))
            }
        }
    }
    
    func printTabel(token: String, tabelNum: Int) {
        
    }
    
    func logout() {
        
        guard isConnectedToInternet else {
            delegate?.networkService(self, failedWith: .connectionError)
            return
        }
        
        // TODO: Change to normal request when server side will be implemented
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let strongSelf = self else { return }
            Thread.sleep(forTimeInterval: 1)
            strongSelf.delegate?.networkServiceDidLogout(strongSelf)
        }
    }
}
