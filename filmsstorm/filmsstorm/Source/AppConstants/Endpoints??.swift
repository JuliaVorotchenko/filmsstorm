//
//  Endpoints.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 02.01.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation
enum Endpoints {
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
        case .getWatchlist: return Endpoints.base + "/account/\(Auth.accountId)/watchlist/movies" + Endpoints.apiKeyParam + "&session_id=\(Auth.sessionId)"
        case .getFavorites:
            return Endpoints.base + "/account/\(Auth.accountId)/favorite/movies" + Endpoints.apiKeyParam + "&session_id=\(Auth.sessionId)"
        case .getRequestToken:
            return Endpoints.base + "/authentication/token/new" + Endpoints.apiKeyParam
        case .login:
            return Endpoints.base + "/authentication/token/validate_with_login" + Endpoints.apiKeyParam
        case .createSessionId:
            return Endpoints.base + "/authentication/session/new" + Endpoints.apiKeyParam
        case .logout:
            return Endpoints.base + "/authentication/session" + Endpoints.apiKeyParam
        case .webAuth:
            return "https://www.themoviedb.org/authenticate/\(Auth.requestToken)?redirect_to=themoviemanager:authenticate"
        case .search(let query):
            return Endpoints.base + "/search/movie" + Endpoints.apiKeyParam + "&query=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""))"
        case .markWatchlist:
            return Endpoints.base + "/account/\(Auth.accountId)/watchlist" + Endpoints.apiKeyParam + "&session_id=\(Auth.sessionId)"
        case .markFavorite:
            return Endpoints.base + "/account/\(Auth.accountId)/favorite" + Endpoints.apiKeyParam + "&session_id=\(Auth.sessionId)"
        case .posterImage(let posterPath):
            return "https://image.tmdb.org/t/p/w500/" + posterPath
        }
    }
    
    var url: URL {
        return URL(string: stringValue)!
    }
}
