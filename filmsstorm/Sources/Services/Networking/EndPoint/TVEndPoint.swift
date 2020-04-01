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
        case getTVShowCredits(model: Identifier)
        case getTVShowDetails(model: Identifier)
        case getTVShowImages(tvID: Int)
        case getTVShowSimilar(model: Identifier)
        case getTVShowVideos(model: Identifier)
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
            case .getTVShowCredits(let model):
                return "/tv/\(String(describing: model.id))/credits"
            case .getTVShowDetails(let model):
                return "/tv/\(String(describing: model.id))"
            case .getTVShowImages(let tvID):
                return "/tv/\(tvID)/images"
            case .getTVShowSimilar(let model):
                return "/tv/\(String(describing: model.id))/similar"
            case .getTVShowVideos(let model):
                return "/tv/\(String(describing: model.id))/videos"
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
            .getTVShowCredits,
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
            .getTVShowImages,
            .getTVShowLatest,
            .getTVShowAiring,
            .getTVShowPopular,
            .getTVShowTopRated:
                return .requestParameters(bodyParameters: nil, urlParameters: [Headers.apiKey: Headers.apiKeyValue])
                
            case
            .getTVShowCredits(let model),
            .getTVShowDetails(let model),
            .getTVShowSimilar(let model),
            .getTVShowVideos(let model):
                return .requestParameters(bodyParameters: nil, urlParameters: [Headers.apiKey: Headers.apiKeyValue,
                                                                               Headers.tvId: model.id])
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
