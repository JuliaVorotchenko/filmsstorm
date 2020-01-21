//
//  DiscoverEndPoint.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 15.01.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation
extension APIEndPoint {
    enum DiscoverEndPoint: EndPointType {
        case movieDiscover
        case tvDiscover
        
        var base: String {
            return "https://api.themoviedb.org/3"
        }
        
        var baseURL: URL {
            guard let url = URL(string: base) else { fatalError("baseURL could not be configured.")}
            return url
        }
        
        var path: String {
            switch self {
            case .movieDiscover:
                return "/discover/movie"
            case .tvDiscover:
                return "/discover/tv"
            }
        }
        
        var httpMethod: HTTPMethod {
            switch self {
            case   .movieDiscover,
                   .tvDiscover:
                return .get
            }
        }
        
        var task: HTTPTask {
            switch self {
            case .movieDiscover,
                 .tvDiscover:
                return .requestParameters(bodyParameters: nil, urlParameters:  [Headers.apiKey: Headers.apiKeyValue])
            }
        }
    }
}
