//
//  ParameterEncoding.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 08.01.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

typealias Parameters = [String: Any]

protocol ParameterEncoder {
    static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}
