//
//  AuthEndPoint.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 14.01.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

extension APIEndPoint {
    
    enum AuthEndPoint: EndPointType {
        case createRequestToken
        case validateRequestToken(AuthRequestModel)
        case createSession(SessionRequestBody)
        case logout(sessionID: String)
        
        var base: String {
            return "https://api.themoviedb.org/3"
        }
        
        var baseURL: URL {
            guard let url = URL(string: base) else { fatalError("baseURL could not be configured.")}
            return url
        }
        
        var path: String {
            switch self {
            case .createRequestToken:
                return "/authentication/token/new"
            case .validateRequestToken:
                return "/authentication/token/validate_with_login"
            case .createSession:
                return "/authentication/session/new"
            case .logout:
                return "/authentication/session"
            }
        }
        
        var httpMethod: HTTPMethod {
            switch self {
            case .createRequestToken:
                return .get
            case .createSession, .validateRequestToken:
                return .post
            case .logout:
                return .delete
                
            }
        }
        
        var task: HTTPTask {
            switch self {
            case .createRequestToken:
                return .requestParameters(bodyParameters: nil, urlParameters:  [Headers.apiKey: Headers.apiKeyValue])
                
            case .validateRequestToken(let model):
                return .requestParamAndHeaders(model: model,
                                               urlParameters: [Headers.apiKey: Headers.apiKeyValue],
                                               additionHeaders: [Headers.contentType: Headers.contentTypeValue])
                
            case .createSession(let model):
                return .requestParamAndHeaders(model: model,
                                               urlParameters: [Headers.apiKey: Headers.apiKeyValue],
                                               additionHeaders: [Headers.contentType: Headers.contentTypeValue])
                
            case .logout(let sessionID):
                return .requestParametersAndHeaders(bodyParameters: ["session_id": sessionID],
                                                    urlParameters: [Headers.apiKey: Headers.apiKeyValue],
                                                    additionHeaders: [Headers.contentType: Headers.contentTypeValue])
            }
        }
    }
}
