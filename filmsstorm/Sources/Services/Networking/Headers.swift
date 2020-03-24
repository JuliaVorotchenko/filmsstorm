//
//  Constants.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 10.01.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

struct  Headers {
    static let contentType = "Content-type"
    static let contentTypeValue = "application/json"
    static let apiKey = "api_key"
    static let apiKeyValue = KeysManager.retreieveKeys().apiKey
    static let region = "region"
    static let ua = "ua"
    static let sessionID = "session_id"
    static let tvId = "tv_id"
    static let movieId = "movie_id"
    
}
