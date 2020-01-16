//
//  ReviewEndPoint.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 15.01.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

extension APIEndPoint {
    enum ReviewEndPoint: EndPointType {
        case getReviewDetails(reviewID: String)
        var base: String {
            return "https://api.themoviedb.org/3"
        }
        
        var baseURL: URL {
            guard let url = URL(string: base) else { fatalError("baseURL could not be configured.")}
            return url
        }
        
        var path: String {
            switch self {
            case .getReviewDetails(let reviewID):
                return "/review/\(reviewID)"
            }
        }
        
        var httpMethod: HTTPMethod {
            switch self {
            case
            
            .getReviewDetails:
                return .get
            }
        }
        
        var task: HTTPTask {
            switch self {
            case
            .getReviewDetails:
                return .requestParameters(bodyParameters: nil, urlParameters:  [Headers.apiKey: Headers.apiKeyValue])
            }
        }
    }
}
