//
//  MarkFavorite.swift
//  TheMovieManager
//
//  Created by Olajide Afeez on 3/8/2021.
//

import Foundation

struct MarkFavorite: Codable {
    let mediaType: String
    let mediaId: Int
    let favorite: Bool
    
    enum CodingKeys: String, CodingKey {
        case mediaType = "media_type"
        case mediaId = "media_id"
        case favorite = "favorite"
    }
    
}
