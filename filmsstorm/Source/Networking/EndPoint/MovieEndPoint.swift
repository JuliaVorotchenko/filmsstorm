//
//  MovieEndPoint.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 08.01.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

public enum MovieApi {
    
    // MARK: - Authentication cases
    case createRequestToken
    case validateRequestToken(username: String, password: String, requsetToken: String)
    case createSession(validToken: String)
    case logout(sessionID: String)
    
    // MARK: - Account cases
    case getAccountDetails
    
}

extension MovieApi: EndPointType {
    var httpMethod: HTTPMethod {
        switch self {
        case .createRequestToken,
             .getAccountDetails:
            return .get
        case .validateRequestToken,
             .createSession:
            return .post
        case .logout:
            return .delete
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .createRequestToken:
            return .requestParameters(bodyParameters: nil, urlParameters: [Headers.apiKey: Headers.apiKeyValue])
            
        case .validateRequestToken(let username, let password, let requestToken):
            return .requestParamettersAndHeaders(bodyParameters: ["username": username,
                                                                  "password": password,
                                                                  "request_token": requestToken],
                                                 urlParameters: [Headers.apiKey: Headers.apiKeyValue],
                                                 additionHeaders: [Headers.contentType: Headers.contentTypeValue])
            
        case .createSession(let validToken):
            return .requestParamettersAndHeaders(bodyParameters: ["request_token": validToken],
                                                 urlParameters: [Headers.apiKey: Headers.apiKeyValue],
                                                 additionHeaders: [Headers.contentType: Headers.contentTypeValue])
            
        case .getAccountDetails:
            return .requestParameters(bodyParameters: nil,
                                      urlParameters: [Headers.apiKey: Headers.apiKeyValue,
                                                      "session_id": UserDefaultsContainer.session])
        case .logout:
            return .requestParamettersAndHeaders(bodyParameters: ["session_id": UserDefaultsContainer.session],
                                                 urlParameters: [Headers.apiKey: Headers.apiKeyValue],
                                                 additionHeaders: [Headers.contentType: Headers.contentTypeValue])
        }
    }
    
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
        case .getAccountDetails:
            return "/account"
        case .validateRequestToken:
            return  "/authentication/token/validate_with_login"
        case .createSession:
            return "/authentication/session/new"
        case .logout:
            return "/authentication/session"
        }
        
    }
}
