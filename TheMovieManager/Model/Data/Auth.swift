//
//  Auth.swift
//  TheMovieManager
//
//  Created by Olajide Afeez on 03/08/2021.
//

import Foundation

class Auth {
    static var shared: Auth!
    
    var accountId = 0
    var requestToken = ""
    var sessionId = ""
    
    var logged: Bool {
        return !sessionId.isEmpty
    }
    
    private var defaults: UserDefaults {
        return UserDefaults.standard
    }
    
    init() {
        if let sessionId = defaults.string(forKey: "sessionId") {
            self.sessionId = sessionId
        }
    }
    
    
    func save(sessionId: String) {
        self.sessionId = sessionId
        defaults.setValue(sessionId, forKey: "sessionId")
    }
    
     func clear() {
        requestToken = ""
        sessionId = ""
        defaults.removeObject(forKey: "sessionId")
    }
}
