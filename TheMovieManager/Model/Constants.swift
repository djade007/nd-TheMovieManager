//
//  Constants.swift
//  TheMovieManager
//
//  Created by Olajide Afeez on 05/08/2021.
//  Copyright © 2021 Udacity. All rights reserved.
//

import Foundation

struct K {
    struct ProductionServer {
        static let baseURL = "https://api.themoviedb.org"
        static let apiVersion = "3"
        
        // Todo: Update your api key.
        // The provided one will be revoked after app approval.
        static let apiKey = "28e71975f8340be7e6e2eadda708e20f"
        
        static func resolvePoster(_ path: String) -> URL {
            return URL(string: "https://image.tmdb.org/t/p/w500/\(path)")!
        }
        
        static func webAuth(_ requestToken: String) -> URL {
            return URL(string: "https://www.themoviedb.org/authenticate/\(requestToken)?redirect_to=themoviemanager:authenticate")!
        }
    }
    
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}

enum ContentType: String {
    case json = "application/json"
}
