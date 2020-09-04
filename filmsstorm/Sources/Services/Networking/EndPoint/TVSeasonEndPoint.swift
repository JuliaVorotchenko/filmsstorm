//
//  TVSeasonEndPoint.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 16.01.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation
extension APIEndPoint {
    enum TVSeasonEndPoint: EndPointType {
        case getTVSeasonDetails(tvID: Int, seasonNumber: Int)
        case getTVSeasonImages(tvID: Int, seasonNumber: Int)
        
        var base: String {
            return "https://api.themoviedb.org/3"
        }
        
        var baseURL: URL {
            guard let url = URL(string: base) else { fatalError("baseURL could not be configured.")}
            return url
        }
        
        var path: String {
            switch self {
                
            case .getTVSeasonDetails(let tvID, let seasonNumber):
                return "/tv/\(tvID)/season/\(seasonNumber)"
            case .getTVSeasonImages(let tvID, let seasonNumber):
                return "/tv/\(tvID)/season/\(seasonNumber)/images"
            }
        }
        
        var httpMethod: HTTPMethod {
            switch self {
            case
            .getTVSeasonDetails,
            .getTVSeasonImages:
                return .get
            }
        }
        
        var task: HTTPTask {
            switch self {
                
            case
            .getTVSeasonDetails,
            .getTVSeasonImages:
                return .requestParameters(bodyParameters: nil, urlParameters: [Headers.apiKey: Headers.apiKeyValue])
            }
        }
    }
}
