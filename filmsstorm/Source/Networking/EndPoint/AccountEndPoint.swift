//
//  AccountEndPoint.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 15.01.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

extension APIEndPoint {
    
    enum AccountEndPoint: EndPointType {
        var base: String {
            return "https://api.themoviedb.org/3"
        }
        
        var baseURL: URL {
            guard let url = URL(string: base) else { fatalError("baseURL could not be configured.")}
            return url
        }
        
        var path: String {
            switch self {
            case .getAccountDetails:
                return "/account"
            case .getFavouriteMovies(_, let accountID):
                return "/account/\(accountID)/favorite/movies"
            case .getFavouriteTVShows(_, let accountID):
                return "/account/\(accountID)/favorite/tv"
            case .markAsFavourite(_, _, _, _, let accountID):
                return "/account/\(accountID)/favorite"
            case .getRatedMovies(_, let accountID):
                return "/account/\(accountID)/rated/movies"
            case .getRatedTVShows(let accountID, _):
                return "/account/\(accountID)/rated/movies"
            }
        }
        var httpMethod: HTTPMethod {
            switch self {
            case .getAccountDetails,
                 .getFavouriteMovies,
                 .getFavouriteTVShows,
                 .getRatedMovies,
                 .getRatedTVShows:
                return .get
                
            case .markAsFavourite:
                return .post
            }
        }
        
        var task: HTTPTask {
            switch self {
                
            case  .getRatedMovies,
                  .getRatedTVShows,
                  .getFavouriteMovies,
                  .getFavouriteTVShows:
                return .requestParameters(bodyParameters: nil, urlParameters:  ["api_key": "f4559f172e8c6602b3e2dd52152aca52"])
            case .getAccountDetails(let sessionID):
                return .requestParameters(bodyParameters: nil, urlParameters: ["session_id": sessionID,
                                                                               Headers.apiKey: Headers.apiKeyValue])
            case .markAsFavourite(_, let mediaType, let mediaID, let favourite, _):
                return .requestParametersAndHeaders(bodyParameters: ["media_type": mediaType,
                                                                     "media_id": mediaID,
                                                                     "favorite": favourite], urlParameters: [Headers.apiKey: Headers.apiKeyValue], additionHeaders: [Headers.contentType: Headers.contentTypeValue])
            }
        }
        case getAccountDetails(sessionID: String)
        case getFavouriteMovies(sessionID: String, accountID: Int)
        case getFavouriteTVShows(sessionID: String, accountID: Int)
        case markAsFavourite(sessionID: String, mediaType: String, mediaID: String, favourite: Bool, accountID: Int)
        case getRatedMovies(sessionID: String, accountID: Int)
        case getRatedTVShows(accountID: String, sessionID: String)
    }
}
