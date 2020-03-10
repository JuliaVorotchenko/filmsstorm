//
//  File.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 10.03.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

struct ShowDeailsRequestModel: Codable {
    let apiKey: String
    let id: Int
    
    enum CodingKeys: String, CodingKey {
        case apiKey = "api_key"
        case id = "tv_id"
    }
}
