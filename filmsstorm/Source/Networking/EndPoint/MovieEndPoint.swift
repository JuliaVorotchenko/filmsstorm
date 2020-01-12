//
//  MovieEndPoint.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 08.01.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

public enum MovieApi {
    
    // MARK: - Authentication cases
    case createRequestToken
    case validateRequestToken(username: String, password: String, requestToken: String)
    case createSession(validToken: String)
    case logout(sessionID: String)
    
    // MARK: - Account cases
    case getAccountDetails
    case getFavouriteMovies(accountId: Int, sessionID: String)
    case getFavouriteTVShows(accountId: Int)
    case markAsFavourite(accountId: Int, sessionID: String)
    case getRatedMovies(accountId: Int)
    case getRatedTVShows(accountId: Int)
    
    // MARK: - Discover
    case movieDiscover
    case tvDiscover
    
    // MARK: - Movies
    case getMovieDetails(movieID: Int)
    case getMovieImages(movieID: Int)
    case getMovieVideos(movieID: Int)
    case getMovieSimilars(movieID: Int)
    case getMovieReviews(movieID: Int)
    case rateMovie(movieID: Int, sessionID: String)
    case deleteMovieRating(movieID: Int, sessionID: String)
    case getMovieLatest
    case getMovieNowPlaying
    case getMoviePopular
    case getMovieTopRated
    
    // MARK: - People
    case getPeopleDetails(personId: Int)
    case getPeopleMostPopular
    
    // MARK: - Reviews
    case getReviewDetails(reviewId: Int)
    
    // MARK: - Search
    case search(query: String)
    
    // MARK: - TV
    case getTVShowDetails(tvID: Int)
    case getTVShowImages(tvID: Int)
    case getTVShowSimilar(tvID: Int)
    case getTVShowVideos(tvID: Int)
    case rateTVShow(tvID: Int, sessionID: String)
    case deleteTVShowRating(tvID: Int, sessionID: String)
    case getTVShowLatest
    case getTVShowAiring
    case getTVShowPopular
    case getTVShowTopRated
    
    // MARK: - TV Season
    case getTVSeasonDetails(tvID: Int, seasonNumber: Int)
    case getTVSeasonImages(tvID: Int, seasonNumber: Int, episodeNumber: Int)
    
}

extension MovieApi: EndPointType {
    var httpMethod: HTTPMethod {
        switch self {
        case .createRequestToken,
             .getAccountDetails,
             .getFavouriteMovies,
             .getFavouriteTVShows,
             .getRatedMovies,
             .getRatedTVShows,
             .getMovieDetails,
             .getMovieImages,
             .getMovieVideos,
             .getMovieSimilars,
             .getMovieReviews,
             .getMovieLatest,
             .getMovieNowPlaying,
             .getMoviePopular,
             .getMovieTopRated,
             .getPeopleDetails,
             .getPeopleMostPopular,
             .getReviewDetails,
             .getTVShowDetails,
             .getTVShowImages,
             .getTVShowSimilar,
             .getTVShowVideos,
             .getTVShowLatest,
             .getTVShowAiring,
             .getTVShowPopular,
             .getTVShowTopRated,
             .getTVSeasonDetails,
             .movieDiscover,
             .tvDiscover,
             .getTVSeasonImages:
            return .get
            
        case .validateRequestToken,
             .createSession,
             .markAsFavourite,
             .rateMovie,
             .search,
             .rateTVShow:
            return .post
            
        case .logout,
             .deleteMovieRating,
             .deleteTVShowRating:
            return .delete
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .createRequestToken:
            return .requestParameters(bodyParameters: nil, urlParameters: [Headers.apiKey: Headers.apiKeyValue])
            
        case .validateRequestToken(let username, let password, let requestToken):
            return .requestParametersAndHeaders(bodyParameters: ["username": username,
                                                                 "password": password,
                                                                 "request_token": requestToken],
                                                urlParameters: [Headers.apiKey: Headers.apiKeyValue],
                                                additionHeaders: [Headers.contentType: Headers.contentTypeValue])
            
        case .createSession(let validToken):
            return .requestParametersAndHeaders(bodyParameters: ["request_token": validToken],
                                                urlParameters: [Headers.apiKey: Headers.apiKeyValue],
                                                additionHeaders: [Headers.contentType: Headers.contentTypeValue])
            
        case .getAccountDetails:
            return .requestParameters(bodyParameters: nil,
                                      urlParameters: [Headers.apiKey: Headers.apiKeyValue,
                                                      "session_id": UserDefaultsContainer.session])
        case .logout:
            return .requestParametersAndHeaders(bodyParameters: ["session_id": UserDefaultsContainer.session],
                                                urlParameters: [Headers.apiKey: Headers.apiKeyValue],
                                                additionHeaders: [Headers.contentType: Headers.contentTypeValue])
        case .getFavouriteMovies(let accountId):
            <#code#>
        case .getFavouriteTVShows(let accountId):
            <#code#>
        case .markAsFavourite(let accountId, let sessionID):
            <#code#>
        case .getRatedMovies(let accountId):
            <#code#>
        case .getRatedTVShows(let accountId):
            <#code#>
        case .movieDiscover:
            <#code#>
        case .tvDiscover:
            <#code#>
        case .getMovieDetails(let movieID):
            <#code#>
        case .getMovieImages(let movieID):
            <#code#>
        case .getMovieVideos(let movieID):
            <#code#>
        case .getMovieSimilars(let movieID):
            <#code#>
        case .getMovieReviews(let movieID):
            <#code#>
        case .rateMovie(let movieID, let sessionID):
            <#code#>
        case .deleteMovieRating(let movieID, let sessionID):
            <#code#>
        case .getMovieLatest:
            <#code#>
        case .getMovieNowPlaying:
            <#code#>
        case .getMoviePopular:
            <#code#>
        case .getMovieTopRated:
            <#code#>
        case .getPeopleDetails(let personId):
            <#code#>
        case .getPeopleMostPopular:
            <#code#>
        case .getReviewDetails(let reviewId):
            <#code#>
        case .search(let query):
            <#code#>
        case .getTVShowDetails(let tvID):
            <#code#>
        case .getTVShowImages(let tvID):
            <#code#>
        case .getTVShowSimilar(let tvID):
            <#code#>
        case .getTVShowVideos(let tvID):
            <#code#>
        case .rateTVShow(let tvID, let sessionID):
            <#code#>
        case .deleteTVShowRating(let tvID, let sessionID):
            <#code#>
        case .getTVShowLatest:
            <#code#>
        case .getTVShowAiring:
            <#code#>
        case .getTVShowPopular:
            <#code#>
        case .getTVShowTopRated:
            <#code#>
        case .getTVSeasonDetails(let tvID, let seasonNumber):
            <#code#>
        case .getTVSeasonImages(let tvID, let seasonNumber, let episodeNumber):
            <#code#>
        }
    }
    
    var base: String {
        return "https://api.themoviedb.org/3"
    }
    
    var baseURL: URL {
        guard let url = URL(string: base) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case .createRequestToken:
            return "/authentication/token/new"
        case .getAccountDetails:
            return "/account"
        case .validateRequestToken:
            return  "/authentication/token/validate_with_login"
        case .createSession:
            return "/authentication/session/new"
        case .logout:
            return "/authentication/session"
        }
        
    }
}
