//
//  TMDBRouter.swift
//  TheMovieManager
//
//  Created by Olajide Afeez on 05/08/2021.
//  Copyright © 2021 Udacity. All rights reserved.
//

import Foundation
import Alamofire


enum TMDBRouter: URLRequestConvertible {
    case getWatchlist
    case getFavorites
    case getRequestToken
    case login(username:String, password:String)
    case createSessionId
    case logout
    case search(String)
    
    case markWatchlist(movieId: Int, watchList: Bool)
    
    case markFavorite(movieId: Int, favorite: Bool)
    
    private var auth: Auth {
        return Auth.shared
    }
    
    // MARK: - HTTPMethod
    private var method: HTTPMethod {
        switch self {
        case .getWatchlist, .getFavorites, .getRequestToken, .search:
            return .get
        case .login, .createSessionId, .markWatchlist, .markFavorite:
            return .post
        case .logout:
            return .delete
        }
    }
    
    // MARK: - Path
    private var path: String {
        switch self {
        case .getWatchlist:
            return "/account/:accountId/watchlist/movies"
        case .getFavorites:
            return "/account/:accountId/favorite/movies"
        case .getRequestToken:
            return "/authentication/token/new"
        case .login:
            return "/authentication/token/validate_with_login"
        case .createSessionId:
            return "/authentication/session/new"
        case .logout:
            return "/authentication/session"
        case .search:
            return "/search/movie"
        case .markWatchlist:
            return "/account/\(auth.accountId)/watchlist"
        case .markFavorite:
            return "/account/\(auth.accountId)/favorite"
        }
    }
    
    // MARK: - Parameters
    private var parameters: Parameters? {
        switch self {
        case .getWatchlist, .getFavorites, .getRequestToken, .search:
            return nil
        case .login(let username, let password):
            return ["username": username, "password": password, "request_token": auth.requestToken]
        case .createSessionId:
            return ["request_token": auth.requestToken]
        case .logout:
            return ["session_id": auth.sessionId]
        case .markWatchlist(let movieId, let watchlist):
            return ["media_id": movieId, "media_type": "movie", "watchlist": watchlist]
        case .markFavorite(let movieId, let favorite):
            return ["media_id": movieId, "media_type": "movie", "favorite": favorite]
        }
        
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        
        var urlComp = URLComponents(string: K.ProductionServer.baseURL)!
        
        // add api version
        // update accountId in path
        urlComp.path = "/\(K.ProductionServer.apiVersion)" + path.replacingOccurrences(of: ":accountId", with: String(auth.accountId))
        
        var queries = [URLQueryItem(name: "api_key", value: K.ProductionServer.apiKey)]
        
        if auth.logged {
            queries.append(URLQueryItem(name: "session_id", value: auth.sessionId))
        }
        
    
        if case TMDBRouter.search(let query) = self {
            queries.append(URLQueryItem(name: "query", value: query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""))
        }
        
        urlComp.queryItems = queries
        
        var urlRequest = URLRequest(url: try! urlComp.asURL())
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
 
        // Parameters
        if let parameters = parameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        
        return urlRequest
    }
}
