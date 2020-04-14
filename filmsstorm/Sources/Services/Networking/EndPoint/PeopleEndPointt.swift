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
        case getPeopleDetails(personID: Identifier)
        case getPeopleMostPopular
        case getCombinedCredit(personID: Identifier)
        
        var base: String {
            return "https://api.themoviedb.org/3"
        }
        
        var baseURL: URL {
            guard let url = URL(string: base) else { fatalError("baseURL could not be configured.")}
            return url
        }
        
        var path: String {
            switch self {
            case .getPeopleDetails(let model):
                return "/person/\(String(describing: model.idValue))"
            case .getPeopleMostPopular:
                return "/person/popular"
            case .getCombinedCredit(let model):
                return "/person/\(String(describing: model.idValue))/combined_credits"
            }
        }
        
        var httpMethod: HTTPMethod {
            switch self {
            case
            .getCombinedCredit,
            .getPeopleDetails,
            .getPeopleMostPopular:
                return .get
            }
            
        }
        
        var task: HTTPTask {
            switch self {
            case
            .getCombinedCredit,
            .getPeopleMostPopular,
            .getPeopleDetails:
                return .requestParameters(bodyParameters: nil, urlParameters:  [Headers.apiKey: Headers.apiKeyValue])
            }
        }
    }
}
