//
//  NetworkError.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 08.01.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

protocol Descriptable {
    var stringDescription: String { get }
}

enum NetworkError: Error, Descriptable {
    case parametersNil
    case encodingFailed
    case missingURL
    case resultError
    case networkingResponse(NetworkResponse)
    
    case other(URLError: Error?)
    
    var stringDescription: String {
        switch self {
        case .parametersNil:
            return "Parameters were nil."
        case .encodingFailed:
            return "Parameters encoding failed."
        case .missingURL:
            return "URL is nil."
        case .resultError:
            return "Couldnt`t parse resultError"
        case .networkingResponse(let response):
            return response.rawValue
        case .other(let error): return error?.localizedDescription ?? "other error"
        }
    }
}

enum NetworkResponse: String, Error {
    case succsess
    case authenticationError = "You need to be autencicated first."
    case badRequest = "Bad request."
    case outdated = "The URL you request is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We couldn`t to decode response."
}

enum AppError: Error, Descriptable {
    case networkingError(NetworkError)
    case unowned(Error?)
    
    var stringDescription: String {
        switch self {
        case .networkingError(let error):
            return error.stringDescription
        case .unowned(let error):
            return error.debugDescription
        }
    }
}
