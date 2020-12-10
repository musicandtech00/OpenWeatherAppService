//
//  LoginManager.swift
//  OpenWeatherAppService
//
//  Created by Curtis Wiseman on 12/10/20.
//

import Foundation
import KeychainAccess

class KeyChainManager {
    
    var isLoggedIn: Bool {
        keyChain["accessToken"] != nil
    }
    
    static let shared = KeyChainManager()
    
    private let keyChain = Keychain(service: "com.curtiswiseman.openweatherappservice")
    
    init() { }
    
    func store(token: String) {
        keyChain["accessToken"] = token
    }
}
