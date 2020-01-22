//
//  PeopleEndPointt.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 15.01.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

extension APIEndPoint {
    enum PeopleEndPoint: EndPointType {
        case getPeopleDetails(personID: Int)
        case getPeopleMostPopular
        
        var base: String {
            return "https://api.themoviedb.org/3"
        }
        
        var baseURL: URL {
            guard let url = URL(string: base) else { fatalError("baseURL could not be configured.")}
            return url
        }
        
        var path: String {
            switch self {
            case .getPeopleDetails(let personID):
                return "/person/\(personID)"
            case .getPeopleMostPopular:
                return "/person/popular"
            }
        }
        
        var httpMethod: HTTPMethod {
            switch self {
            case
            .getPeopleDetails,
            .getPeopleMostPopular:
                return .get
            }
            
        }
        
        var task: HTTPTask {
            switch self {
            case
            .getPeopleMostPopular,
            .getPeopleDetails:
                return .requestParameters(bodyParameters: nil, urlParameters:  [Headers.apiKey: Headers.apiKeyValue])
            }
        }
    }
}
