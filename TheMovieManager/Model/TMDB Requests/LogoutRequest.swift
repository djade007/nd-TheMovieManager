//
//  Logout.swift
//  TheMovieManager
//
//  Created by Olajide Afeez on 3/8/2021.
//

import Foundation

struct LogoutRequest: Codable {
    let sessionId: String
    
    enum CodingKeys: String, CodingKey {
        case sessionId = "session_id"
    }
}
