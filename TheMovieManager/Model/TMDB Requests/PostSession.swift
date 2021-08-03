//
//  PostSession.swift
//  TheMovieManager
//
//  Created by Olajide Afeez on 3/8/2021.
//

import Foundation

struct PostSession: Codable {
    
    let requestToken: String
    
    enum CodingKeys: String, CodingKey {
        case requestToken = "request_token"
    }
    
}
