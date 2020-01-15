//
//  MovieEndPoint.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 08.01.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

enum APIEndPoint {
    
    case auth(AuthEndPoint)
    case account(AccountEndPoint)
    case discover(DiscoverEndPoint)
    case movie(MovieEndPoint)
    case people(PeopleEndPoint)
    
    
    // MARK: - Reviews case
    case review(ReviewEndPoint)
   
    // MARK: - Search case
    case search(query: String)
    
    // MARK: - TV cases
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
    
    // MARK: - TV Season cases
    case getTVSeasonDetails(tvID: Int, seasonNumber: Int)
    case getTVSeasonImages(tvID: Int, seasonNumber: Int)
    
}

extension APIEndPoint: EndPointType {
    
    var httpMethod: HTTPMethod {
        switch self {
        case .auth(let model):
            return model.httpMethod
            
        case .account(let model):
            return model.httpMethod
            
        case .discover(let model):
            return model.httpMethod
            
        case .movie(let model):
        return model.httpMethod
        case .people(let model):
            return model.httpMethod
        case .review(let model):
            return model.httpMethod
        case
        
        .getTVShowDetails,
        .getTVShowImages,
        .getTVShowSimilar,
        .getTVShowVideos,
        .getTVShowLatest,
        .getTVShowAiring,
        .getTVShowPopular,
        .getTVShowTopRated,
        .getTVSeasonDetails,
        .getTVSeasonImages:
            return .get
            
        case
        .search,
        .rateTVShow:
            return .post
            
        case
        .deleteTVShowRating:
            return .delete
            
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .auth(let model):
            return model.task
        case .account(let model):
            return model.task
        case .discover(let model):
            return model.task
        case .movie(let model):
            return model.task
        case .people(let model):
            return model.task
        case .review(let model):
        return model.task
        case
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
    
        .search:
            return .requestParameters(bodyParameters: nil, urlParameters:  ["api_key": "f4559f172e8c6602b3e2dd52152aca52"])
            
      
        case
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
        case .auth(let model):
            return model.path
        case .account(let model):
            return model.path
        case .discover(let model):
            return model.path
        case .movie(let model):
            return model.path
        case .people(let model):
            return model.path
        case .review(let model):
            return model.path
       
       
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

