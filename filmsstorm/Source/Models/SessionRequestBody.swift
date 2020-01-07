//
//  SessionRequestBody.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 30.12.2019.
//  Copyright © 2019 Alexander Andriushchenko. All rights reserved.
//

import Foundation

struct SessionRequestBody: Codable {
    var requestToken: String
    
    enum CodingKeys: String, CodingKey {
        case requestToken = "request_token"
    }
}
