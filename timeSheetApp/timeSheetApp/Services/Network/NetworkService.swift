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
    case receiveDataError
    case unknownError
    case validationError(_ error: Error)
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
    func printTabel(tabelNum: Int)
    func logout()
}

final class NetworkServiceImplementation {
    
    static let shared = NetworkServiceImplementation()
    
    private let sessionManager = Alamofire.Session.default
    private let userDefaults = UserDefaults.standard
    
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
                    strongSelf.delegate?.networkService(strongSelf, failedWith: .receiveDataError)
                    return
                }
                do {
                    let parsedResponse = try JSONDecoder().decode(AuthAnswer.self, from: data)
                    strongSelf.userDefaults.email = email
                    strongSelf.userDefaults.token = parsedResponse.accessToken
                    strongSelf.delegate?.networkServiceDidSignIn(strongSelf)
                }
                catch {
                    strongSelf.delegate?.networkService(strongSelf, failedWith: .receiveDataError)
                    return
                }
            case .failure(let error):
                strongSelf.delegate?.networkService(strongSelf, failedWith: .validationError(error))
            }
        }
    }
    
    func printTabel(tabelNum: Int) {
        
        guard isConnectedToInternet else {
            delegate?.networkService(self, failedWith: .connectionError)
            return
        }
        
        guard let token = userDefaults.token else { return }
        guard let url = URL(string: Config.URLs.printTabel(tabelNum: tabelNum)) else { return }
        
        AF.request(url, method: .post, headers: [
            "Authorization": "Bearer \(token)"
        ]).validate().response { [weak self] responce in
            
            guard let strongSelf = self else { return }
            
            switch responce.result {
            case .success:
                strongSelf.delegate?.networkServiceDidPrintTabel(strongSelf)
            case.failure(let error):
                switch responce.response?.statusCode {
                case 401:
                    strongSelf.delegate?.networkService(strongSelf, failedWith: .unauthorizedError)
                default:
                    strongSelf.delegate?.networkService(strongSelf, failedWith: .validationError(error))
                }
            }
        }
    }
    
    func logout() {
        
        guard isConnectedToInternet else {
            delegate?.networkService(self, failedWith: .connectionError)
            return
        }
        
        // Logout simulation
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let strongSelf = self else { return }
            Thread.sleep(forTimeInterval: 1)
            strongSelf.delegate?.networkServiceDidLogout(strongSelf)
        }
    }
}
