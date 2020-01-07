//
//  Endpoints.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 02.01.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

func getEndpoint() -> URL {
    return Route.login.url
}

enum Route {
    static let base = "https://api.themoviedb.org/3"
    static let apiKeyParam = "?api_key=f4559f172e8c6602b3e2dd52152aca52"
    
    case getWatchlist
    case getFavorites
    case getRequestToken
    case login
    case createSessionId
    case logout
    case webAuth
    case search(String)
    case markWatchlist
    case markFavorite
    case posterImage(String)
    
    var stringValue: String {
        switch self {
        case .getWatchlist: return Route.base + "/account/\(Auth.accountId)/watchlist/movies" + Route.apiKeyParam + "&session_id=\(Auth.sessionId)"
        case .getFavorites:
            return Route.base + "/account/\(Auth.accountId)/favorite/movies" + Route.apiKeyParam + "&session_id=\(Auth.sessionId)"
        case .getRequestToken:
            return Route.base + "/authentication/token/new" + Route.apiKeyParam
        case .login:
            return Route.base + "/authentication/token/validate_with_login" + Route.apiKeyParam
        case .createSessionId:
            return Route.base + "/authentication/session/new" + Route.apiKeyParam
        case .logout:
            return Route.base + "/authentication/session" + Route.apiKeyParam
        case .webAuth:
            return "https://www.themoviedb.org/authenticate/\(Auth.requestToken)?redirect_to=themoviemanager:authenticate"
        case .search(let query):
            return Route.base + "/search/movie" + Route.apiKeyParam + "&query=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""))"
        case .markWatchlist:
            return Route.base + "/account/\(Auth.accountId)/watchlist" + Route.apiKeyParam + "&session_id=\(Auth.sessionId)"
        case .markFavorite:
            return Route.base + "/account/\(Auth.accountId)/favorite" + Route.apiKeyParam + "&session_id=\(Auth.sessionId)"
        case .posterImage(let posterPath):
            return "https://image.tmdb.org/t/p/w500/" + posterPath
        }
    }
    
    var url: URL {
        return URL(string: stringValue)!
    }
}
