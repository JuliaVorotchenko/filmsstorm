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
    case getAccountDetails(sessionID: String)
    case getFavouriteMovies(sessionID: String, accountID: Int)
    case getFavouriteTVShows(sessionID: String, accountID: Int)
    case markAsFavourite(sessionID: String, mediaType: String, mediaID: String, favourite: Bool, accountID: Int)
    case getRatedMovies(sessionID: String, accountID: Int)
    case getRatedTVShows(accountID: String, sessionID: String)
    
    // MARK: - Discover
    case movieDiscover
    case tvDiscover
    
    // MARK: - Movies
    case getMovieDetails(movieID: Int)
    case getMovieImages(movieID: Int)
    case getMovieVideos(movieID: Int)
    case getMovieSimilars(movieID: Int)
    case getMovieReviews(movieID: Int)
    case rateMovie(movieID: Int, rateValue: Int)
    case deleteMovieRating(movieID: Int)
    case getMovieLatest
    case getMovieNowPlaying
    case getMoviePopular
    case getMovieTopRated
    
    // MARK: - People
    case getPeopleDetails(personID: Int)
    case getPeopleMostPopular
    
    // MARK: - Reviews
    case getReviewDetails(reviewID: String)
    
    // MARK: - Search
    case search(query: String)
    
    // MARK: - TV
    case getTVShowDetails(tvID: Int)
    case getTVShowImages(tvID: Int)
    case getTVShowSimilar(tvID: Int)
    case getTVShowVideos(tvID: Int)
    case rateTVShow(tvID: Int, ratingValue: Int)
    case deleteTVShowRating(tvID: Int)
    case getTVShowLatest
    case getTVShowAiring
    case getTVShowPopular
    case getTVShowTopRated
    
    // MARK: - TV Season
    case getTVSeasonDetails(tvID: Int, seasonNumber: Int)
    case getTVSeasonImages(tvID: Int, seasonNumber: Int)
    
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
        case .createRequestToken,
             .movieDiscover,
             .tvDiscover,
             .getMovieLatest,
             .getMovieNowPlaying,
             .getMoviePopular,
             .getMovieTopRated,
             .getPeopleMostPopular,
             .getTVShowDetails,
             .getTVShowImages,
             .getTVShowSimilar,
             .getTVShowVideos,
             .getTVShowLatest,
             .getTVShowAiring,
             .getTVShowPopular,
             .getTVShowTopRated,
             .getTVSeasonDetails,
             .getTVSeasonImages,
             .getRatedMovies,
             .getRatedTVShows,
             .getReviewDetails,
             .getPeopleDetails,
             .getMovieDetails,
             .getMovieImages,
             .getMovieVideos,
             .getMovieSimilars,
             .getMovieReviews,
             .getAccountDetails,
             .getFavouriteMovies,
             .getFavouriteTVShows,
             .search:
            return .requestParameters(bodyParameters: nil, urlParameters:  ["api_key": "f4559f172e8c6602b3e2dd52152aca52"])
            
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
            
        case .logout:
            return .requestParametersAndHeaders(bodyParameters: ["session_id": UserDefaultsContainer.session],
                                                urlParameters: [Headers.apiKey: Headers.apiKeyValue],
                                                additionHeaders: [Headers.contentType: Headers.contentTypeValue])
            
        case .markAsFavourite(_, let mediaType, let mediaID, let favourite, _):
            return .requestParametersAndHeaders(bodyParameters: ["media_type": mediaType,
                                                                 "media_id": mediaID,
                                                                 "favorite": favourite], urlParameters: [Headers.apiKey: Headers.apiKeyValue], additionHeaders: [Headers.contentType: Headers.contentTypeValue])
            
        case .rateMovie(_, let rateValue):
            return .requestParametersAndHeaders(bodyParameters: ["value": rateValue],
                                                urlParameters: [Headers.apiKey: Headers.apiKeyValue],
                                                additionHeaders: [Headers.contentType: Headers.contentTypeValue])
        case .deleteMovieRating,
             .deleteTVShowRating:
            return .requestParametersAndHeaders(bodyParameters: nil,
                                                urlParameters: [Headers.apiKey: Headers.apiKeyValue],
                                                additionHeaders: [Headers.contentType: Headers.contentTypeValue])
            
        case .rateTVShow(_, let ratingValue):
            return .requestParametersAndHeaders(bodyParameters: ["value": ratingValue],
                                                urlParameters: [Headers.apiKey:
                                                    Headers.apiKeyValue],
                                                additionHeaders: [Headers.contentType: Headers.contentTypeValue])
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
        case .getReviewDetails(let reviewID):
            return "/review/\(reviewID)"
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
        case .movieDiscover:
            return "/discover/movie"
        case .tvDiscover:
            return "/discover/tv"
        case .getMovieDetails(let movieID):
            return "/movie/\(movieID)"
        case .getMovieImages(let movieID):
            return "/movie/\(movieID)/images"
        case .getMovieVideos(let movieID):
            return "/movie/\(movieID)/videos"
        case .getMovieSimilars(let movieID):
            return "/movie/\(movieID)/similar"
        case .getMovieReviews(let movieID):
            return "/movie/\(movieID)/reviews"
        case .rateMovie(let movieID, _):
            return "/movie/\(movieID)/rating"
        case .deleteMovieRating(let movieID):
            return "/movie/\(movieID)/rating"
        case .getMovieLatest:
            return "/movie/latest"
        case .getMovieNowPlaying:
            return "/movie/now_playing"
        case .getMoviePopular:
            return "/movie/popular"
        case .getMovieTopRated:
            return "/movie/top_rated"
        case .getPeopleDetails(let personID):
            return "/person/\(personID)"
        case .getPeopleMostPopular:
            return "/person/popular"
        case .search:
            return "/search/multi"
        case .getTVShowDetails(let tvID):
            return "/tv/\(tvID)"
        case .getTVShowImages(let tvID):
            return "/tv/\(tvID)/images"
        case .getTVShowSimilar(let tvID):
            return "/tv/\(tvID)/similar"
        case .getTVShowVideos(let tvID):
            return "/tv/\(tvID)/videos"
        case .rateTVShow(let tvID, _):
            return "/tv/\(tvID)/rating"
        case .deleteTVShowRating(let tvID):
            return "/tv/\(tvID)/rating"
        case .getTVShowLatest:
            return "/tv/latest"
        case .getTVShowAiring:
            return "/tv/airing_today"
        case .getTVShowPopular:
            return "/tv/popular"
        case .getTVShowTopRated:
            return "/tv/top_rated"
        case .getTVSeasonDetails(let tvID, let seasonNumber):
            return "/tv/\(tvID)/season/\(seasonNumber)"
        case .getTVSeasonImages(let tvID, let seasonNumber):
            return "/tv/\(tvID)/season/\(seasonNumber)/images"
        }
        
    }
}
