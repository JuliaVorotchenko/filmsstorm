//
//  Endpoints.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 02.01.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

protocol RoutesProtocol {
    var url: URL { get }
}

enum Route: RoutesProtocol  {
    static let base = "https://api.themoviedb.org/3"
    static let apiKeyParam = "?api_key=f4559f172e8c6602b3e2dd52152aca52"
    static let account = Route.base + "/account"
    static let authentication = Route.base + "/authentication"
    
    case getWatchlist(ConfigureNetworking)
    case getFavorites(ConfigureNetworking)
    case getRequestToken
    case login
    case createSessionId
    case logout
    case search(String)
    case markWatchlist(ConfigureNetworking)
    case markFavorite(ConfigureNetworking)
    case posterImage(String)
    
    private var stringValue: String {
        switch self {
        case .getWatchlist(let model):
            return Route.account
                + "/\(model.accountId)/watchlist/movies"
                + Route.apiKeyParam
                + "&session_id=\(model.sessionId)"
        case .getFavorites(let model):
            return Route.account
                + "/\(model.accountId)/favorite/movies"
                + Route.apiKeyParam
                + "&session_id=\(model.sessionId)"
        case .getRequestToken:
            return Route.authentication + "/token/new" + Route.apiKeyParam
        case .login:
            return Route.authentication + "/token/validate_with_login" + Route.apiKeyParam
        case .createSessionId:
            return Route.authentication + "/session/new" + Route.apiKeyParam
        case .logout:
            return Route.authentication + "/session" + Route.apiKeyParam
        case .search(let query):
            return Route.base
                + "/search/movie"
                + Route.apiKeyParam
                + "&query=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""))"
        case .markWatchlist(let model):
            return Route.account
                + "/\(model.accountId)/watchlist"
                + Route.apiKeyParam
                + "&session_id=\(model.sessionId)"
        case .markFavorite(let model):
            return Route.account
                + "/\(model.accountId)/favorite"
                + Route.apiKeyParam
                + "&session_id=\(model.sessionId)"
        case .posterImage(let posterPath):
            return "https://image.tmdb.org/t/p/w500/" + posterPath
        }
    }
    
    var url: URL {
        return URL(string: stringValue)!
    }
}
