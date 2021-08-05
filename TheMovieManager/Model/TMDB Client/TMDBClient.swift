//
//  TMDBClient.swift
//  TheMovieManager
//
//  Created by Olajide Afeez on 3/8/2021.
//

import Foundation
import Alamofire

class TMDBClient {
    
    static var auth: Auth {
        return Auth.shared
    }
    
    class func getWatchlist(completion: @escaping ([MovieResponse], Error?) -> Void) {
        AF.request(TMDBRouter.getWatchlist)
            .responseDecodable(of: MovieResults.self) {
                (response) in
                if let data = response.value {
                    completion(data.results, nil)
                } else {
                    completion([], response.error)
                }
            }
    }
    
    class func getFavorites(completion: @escaping ([MovieResponse], Error?) -> Void) {
        AF.request(TMDBRouter.getFavorites)
            .responseDecodable(of: MovieResults.self) {
                (response) in
                if let data = response.value {
                    completion(data.results, nil)
                } else {
                    completion([], response.error)
                }
            }
    }
    
    class func getRequestToken(completion: @escaping (Bool, Error?) -> Void) {
        AF.request(TMDBRouter.getRequestToken)
            .responseDecodable(of: RequestTokenResponse.self) {
                (response) in
                if let data = response.value {
                    auth.requestToken = data.requestToken
                    completion(true, nil)
                } else {
                    completion(false, response.error)
                }
            }
    }
    
    class func login(username: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        AF.request(TMDBRouter.login(username: username, password: password))
            .responseDecodable(of: RequestTokenResponse.self) {
                (response) in
                if let data = response.value {
                    auth.requestToken = data.requestToken
                    completion(true, nil)
                } else {
                    var error = response.error?.localizedDescription
                    
                    if response.response?.statusCode == 401 {
                        error = "Invalid username or password"
                    }
                    completion(false, error)
                }
            }
    }
    
    class func createSessionId(completion: @escaping (Bool, Error?) -> Void) {
        AF.request(TMDBRouter.createSessionId)
            .responseDecodable(of: SessionResponse.self) {
                (response) in
                if let data = response.value {
                    auth.save(sessionId: data.sessionId)
                    completion(true, nil)
                } else {
                    completion(false, response.error)
                }
            }
    }
    
    class func logout(completion: @escaping () -> Void) {
        AF.request(TMDBRouter.logout)
            .response {
                (_) in
                completion()
            }
    }
    
    class func search(query: String, completion: @escaping ([MovieResponse], Error?) -> Void) -> DataRequest {
        let request = AF.request(TMDBRouter.search(query))
        
        AF.request(TMDBRouter.search(query))
            .responseDecodable(of: MovieResults.self) {
                (response) in
                if let data = response.value {
                    completion(data.results, nil)
                } else {
                    completion([], response.error)
                }
            }
        
        return request
    }
    
    class func markWatchlist(movieId: Int, watchlist: Bool, completion: @escaping (Bool, Error?) -> Void) {
        AF.request(TMDBRouter.markWatchlist(movieId: movieId, watchList: watchlist))
            .responseDecodable(of: TMDBResponse.self) {
                (response) in
                if let data = response.value {
                    completion(data.statusCode == 1 || data.statusCode == 12 || data.statusCode == 13, nil)
                } else {
                    completion(false, nil)
                }
            }
    }
    
    class func markFavorite(movieId: Int, favorite: Bool, completion: @escaping (Bool, Error?) -> Void) {
        AF.request(TMDBRouter.markFavorite(movieId: movieId, favorite: favorite))
            .responseDecodable(of: TMDBResponse.self) {
                (response) in
                if let data = response.value {
                    completion(data.statusCode == 1 || data.statusCode == 12 || data.statusCode == 13, nil)
                } else {
                    completion(false, nil)
                }
            }
    }
    
}
