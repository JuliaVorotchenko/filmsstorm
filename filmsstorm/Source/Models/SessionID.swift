//
//  SessionID.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 30.12.2019.
//  Copyright © 2019 Alexander Andriushchenko. All rights reserved.
//

import Foundation

struct SessionID: Codable {
    var success: Bool
    var sessionID: String
    
    enum CodingKeys: String, CodingKey {
        case success
        case sessionID = "session_id"
        
    }
}
