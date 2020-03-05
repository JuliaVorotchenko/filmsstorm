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
        case getAccountDetails(sessionID: String)
        case getFavouriteMovies(sessionID: String)
        case getFavouriteTVShows(sessionID: String)
        case addToFavourites(sessionID: String, model: AddFavouritesRequestModel)
        case getRatedMovies(sessionID: String)
        case getRatedTVShows(sessionID: String)
        case addToWatchList(sessionID: String, model: AddWatchListRequestModel)
        case getMoviesWatchList(sessionID: String)
        case getShowsWatchList(sessionID: String)
        
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
                
            case .getFavouriteMovies:
                return "/account/account_id/favorite/movies"
                
            case .getFavouriteTVShows:
                return "/account/account_id/favorite/tv"
                
            case .addToFavourites:
                return "/account/account_id/favorite"
                
            case .getRatedMovies:
                return "/account/account_id/rated/movies"
                
            case .getRatedTVShows:
                return "/account/account_id/rated/movies"
                
            case .addToWatchList:
                return "/account/account_id/watchlist"
                
            case .getMoviesWatchList:
                return "/account/account_id/watchlist/movies"
                
            case .getShowsWatchList:
                return "/account/account_id/watchlist/tv"
            }
        }
        var httpMethod: HTTPMethod {
            switch self {
            case .getAccountDetails,
                 .getFavouriteMovies,
                 .getFavouriteTVShows,
                 .getRatedMovies,
                 .getRatedTVShows,
                 .getMoviesWatchList,
                 .getShowsWatchList:
                return .get
                
            case .addToFavourites,
                 .addToWatchList:
                return .post
            }
        }
        
        var task: HTTPTask {
            switch self {
                
            case  .getRatedMovies,
                  .getRatedTVShows,
                  .getMoviesWatchList,
                  .getShowsWatchList:
                return .requestParameters(bodyParameters: nil, urlParameters:  [Headers.apiKey: Headers.apiKeyValue])
            
            case .getAccountDetails(let sessionID),
                 .getFavouriteMovies(let sessionID),
                 .getFavouriteTVShows(let sessionID):
                return .requestParameters(bodyParameters: nil, urlParameters: ["session_id": sessionID,
                                                                               Headers.apiKey: Headers.apiKeyValue])
            case .addToFavourites(let sessionID, let model):
                return .requestParamAndHeaders(model: model,
                                               urlParameters:  [Headers.apiKey: Headers.apiKeyValue, "session_id": sessionID],
                                               additionHeaders:  [Headers.contentType: Headers.contentTypeValue])
                
            case .addToWatchList(let sessionID, let model):
                return .requestParamAndHeaders(model: model,
                                               urlParameters:  [Headers.apiKey: Headers.apiKeyValue, "session_id": sessionID],
                                               additionHeaders:  [Headers.contentType: Headers.contentTypeValue])
            }
        }
    }
}
