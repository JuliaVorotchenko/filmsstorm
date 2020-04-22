//
//  SearchEndpoint.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 16.01.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

extension APIEndPoint {
    enum SearchEndPoint: EndPointType {
        
        case multiSearch(String)
        case movieSearch(String)
        case tvSearch(String)
        
        var path: String {
            switch self {
            case .multiSearch:
                return "/search/multi"
            case .movieSearch:
                return "/search/movie"
            case .tvSearch:
                return "/search/tv"
            }
        }
        var httpMethod: HTTPMethod {
            switch self {
            case .multiSearch,
                 .movieSearch,
                 .tvSearch:
                return .get
            }
        }
        var task: HTTPTask {
            switch self {
            case.multiSearch(let queryString),
                .movieSearch(let queryString),
                .tvSearch(let queryString):
                return .requestParameters(bodyParameters: nil,
                                          urlParameters: [Headers.apiKey: Headers.apiKeyValue, "query": queryString])
            }
        }
        var base: String {
            return "https://api.themoviedb.org/3"
        }
        var baseURL: URL {
            guard let url = URL(string: base) else { fatalError("baseURL could not be configured.")}
            return url
        }
    }
}
