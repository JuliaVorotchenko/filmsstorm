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
        case search
        var path: String {
            switch self {
            case .search:
                return "/search/multi"
            }
        }
        var httpMethod: HTTPMethod {
            switch self {
            case .search:
                return .post
            }
        }
        var task: HTTPTask {
            switch self {
            case.search:
                return .requestParameters(bodyParameters: nil, urlParameters: [Headers.apiKey: Headers.apiKeyValue])
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
