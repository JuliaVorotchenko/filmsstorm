//
//  TokenModel.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 30.12.2019.
//  Copyright © 2019 Alexander Andriushchenko. All rights reserved.
//

import Foundation

struct RequestToken: Codable {
    var success: Bool
    var expiresAt: String
    var requestToken: String
    
    enum CodingKeys: String, CodingKey {
        case success
        case expiresAt = "expires_at"
        case requestToken = "request_token"
    }
}
