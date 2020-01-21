//
//  TVEndPoint.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 16.01.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation
extension APIEndPoint {
    enum TVEndPoint: EndPointType {
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
        
        var base: String {
            return "https://api.themoviedb.org/3"
        }
        
        var baseURL: URL {
            guard let url = URL(string: base) else { fatalError("baseURL could not be configured.")}
            return url
        }
        
        var path: String {
            switch self {
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
            }
        }
        
        var httpMethod: HTTPMethod {
            switch self {
            case
            .getTVShowDetails,
            .getTVShowImages,
            .getTVShowSimilar,
            .getTVShowVideos,
            .getTVShowLatest,
            .getTVShowAiring,
            .getTVShowPopular,
            .getTVShowTopRated:
                return .get
            case
            .rateTVShow:
                return .post
            case
            .deleteTVShowRating:
                return .delete
            }
        }
        
        var task: HTTPTask {
            switch self {
            case
            .getTVShowDetails,
            .getTVShowImages,
            .getTVShowSimilar,
            .getTVShowVideos,
            .getTVShowLatest,
            .getTVShowAiring,
            .getTVShowPopular,
            .getTVShowTopRated:
                
                return .requestParameters(bodyParameters: nil, urlParameters: [Headers.apiKey: Headers.apiKeyValue])
                
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
    }
}
