//
//  RequestTokenResponse.swift
//  TheMovieManager
//
//  Created by Olajide Afeez on 3/8/2021.
//

import Foundation

struct RequestTokenResponse: Codable {
    
    let success: Bool
    let expiresAt: String
    let requestToken: String
    
    enum CodingKeys: String, CodingKey {
        case success
        case expiresAt = "expires_at"
        case requestToken = "request_token"
    }
}
