//
//  JSONParameterEncoder.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 08.01.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

struct JSONParameterEncoder: ParameterEncoder {
    static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            urlRequest.httpBody = jsonData
            if urlRequest.value(forHTTPHeaderField: Headers.contentType) == nil {
                urlRequest.setValue(Headers.contentTypeValue, forHTTPHeaderField: Headers.contentType)
            }
        } catch {
            throw NetworkError.encodingFailed
        }
    }
}
