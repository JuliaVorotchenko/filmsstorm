//
//  URLParameterEncoder.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 08.01.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

struct URLParameterEncoder: ParameterEncoder {
    
    // MARK: - Static methods
    
    static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        guard let url = urlRequest.url else { throw NetworkError.missingURL }
        
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
            !parameters.isEmpty {
            urlComponents.queryItems = [URLQueryItem]()
            for(key, value) in parameters {
                let queryItem = URLQueryItem(name: key,
                                             value:
                    "\(value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
                urlComponents.queryItems?.append(queryItem)
            }
            urlRequest.url = urlComponents.url
        }
        if urlRequest.value(forHTTPHeaderField: Headers.contentType) == nil {
            urlRequest.setValue(Headers.contentTypeValue, forHTTPHeaderField: Headers.contentType)
        }
    }
}
