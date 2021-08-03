//
//  SessionResponse.swift
//  TheMovieManager
//
//  Created by Olajide Afeez on 3/8/2021.
//

import Foundation

struct SessionResponse: Codable {
    
    let success: Bool
    let sessionId: String
    
    enum CodingKeys: String, CodingKey {
        case success
        case sessionId = "session_id"
    }
    
}
