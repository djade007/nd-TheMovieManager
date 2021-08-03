//
//  Login.swift
//  TheMovieManager
//
//  Created by Olajide Afeez on 3/8/2021.
//

import Foundation

struct LoginRequest: Codable {
    
    let username: String
    let password: String
    let requestToken: String
    
    enum CodingKeys: String, CodingKey {
        case username
        case password
        case requestToken = "request_token"
    }
}
