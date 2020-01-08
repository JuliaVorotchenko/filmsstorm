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
       case validateRequestToken
       case createSession
       case logout
       
       // MARK: - Account
       case getAccountDetails
       
}

extension MovieApi: EndPointType {
    var httpMethod: HTTPMethod {
        switch self {
         case .createRequestToken, .getAccountDetails:
             return .get
        
         case .validateRequestToken, .createSession:
             return .post
         
         case .logout:
             return .delete
         }
    }
    
    var task: HTTPTask {
        switch self {
        case .createRequestToken:
            return .requestParameters(bodyParameters: nil, urlParameters: ["api_key": "f4559f172e8c6602b3e2dd52152aca52"])
            
        case .validateRequestToken:
            return .requestParamettersAndHeaders(bodyParameters: ["username": "filmsstorm",
                                                                  "password": "qwerty1015",
                                                                  "request_token": ""],
                                                 urlParameters: ["api_key": "f4559f172e8c6602b3e2dd52152aca52"],
                                                 additionHeaders: ["Content-Type": "application/json"])
                                                 
        case .createSession:
            return .requestParamettersAndHeaders(bodyParameters: ["request_token": ""],
                                      urlParameters:  ["api_key": "f4559f172e8c6602b3e2dd52152aca52"],
                                      additionHeaders: ["Content-Type": "application/json"])
            
        case .getAccountDetails:
            return .requestParameters(bodyParameters: nil,
                                      urlParameters: ["api_key": "f4559f172e8c6602b3e2dd52152aca52",
                                                      "session_id": ""])
        case .logout:
            return .requestParamettersAndHeaders(bodyParameters: ["session_id": ""],
                                                 urlParameters: ["api_key": "f4559f172e8c6602b3e2dd52152aca52"],
                                                 additionHeaders: ["Content-Type": "application/json"])
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
    
//    var httpMethod: HTTPMethod {
//        switch self {
//        case .createRequestToken,
//             .getAccountDetails:
//            return .get
//
//        case .validateRequestToken,
//             .createSession:
//            return .post
//
//        case .logout:
//            return .delete
//        }
//    }
    
//        var task: HTTPTask {
//            switch self {
//            case .createRequestToken:
//                return .requestParameters(bodyParameters: nil, urlParameters: ["api_key": "f4559f172e8c6602b3e2dd52152aca52"])
//
//            case .validateRequestToken:
//                return .requestParamettersAndHeaders(bodyParameters: ["username": "filmsstorm",
//                                                                      "password": "qwerty1015",
//                                                                      "request_token": ""],
//                                                     urlParameters: ["api_key": "f4559f172e8c6602b3e2dd52152aca52"],
//                                                     additionHeaders: ["Content-Type": "application/json"])
//
//            case .createSession:
//                return .requestParamettersAndHeaders(bodyParameters: ["request_token": ""],
//                                          urlParameters:  ["api_key": "f4559f172e8c6602b3e2dd52152aca52"],
//                                          additionHeaders: ["Content-Type": "application/json"])
//
//            case .getAccountDetails:
//                return .requestParameters(bodyParameters: nil,
//                                          urlParameters: ["api_key": "f4559f172e8c6602b3e2dd52152aca52",
//                                                          "session_id": ""])
//            case .logout:
//                return .requestParamettersAndHeaders(bodyParameters: ["session_id": ""],
//                                                     urlParameters: ["api_key": "f4559f172e8c6602b3e2dd52152aca52"],
//                                                     additionHeaders: ["Content-Type": "application/json"])
//            }
//        }
    }
}
