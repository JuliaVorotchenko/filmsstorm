//
//  ShowCreditsModel.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 24.03.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

struct ShowCast: Codable, Hashable {
    let character: String?
    let creditID: String?
    let gender: Int?
    let id: Int?
    let name: String?
    let order: Int?
    let profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case character = "character"
        case creditID = "credit_id"
        case gender = "gender"
        case id = "id"
        case name = "name"
        case order = "order"
        case profilePath = "profile_path"
    }
}

struct ShowCreditsModel: Codable, Hashable {
    let cast: [ShowCast]?
    let crew: [MediaCrew]?
    let id: Int?
    
    enum CodingKeys: String, CodingKey {
        case cast
        case crew
        case id
    }
    
}
