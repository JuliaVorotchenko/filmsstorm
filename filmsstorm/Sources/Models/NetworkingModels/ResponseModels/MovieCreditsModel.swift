//
//  MovieCreditModels.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 24.03.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

struct MovieCast: Codable, Hashable {
    let castID: Int?
    let character: String?
    let creditID: String?
    let gender: Int?
    let id: Int?
    let name: String?
    let order: Int?
    let profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case castID = "cast_id"
        case character = "character"
        case creditID = "credit_id"
        case gender = "gender"
        case id = "id"
        case name = "name"
        case order = "order"
        case profilePath = "profile_path"
    }
}

struct MediaCrew: Codable, Hashable {
    let creditID: String?
    let departament: String?
    let gender: Int?
    let id: Int?
    let job: String?
    let name: String?
    let profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case creditID = "credit_id"
        case departament = "department"
        case gender = "gender"
        case id = "id"
        case job = "job"
        case name = "name"
        case profilePath = "profile_path"
    }
}

struct MovieCreditsModel: Codable, Hashable {
    let id: Int?
    let cast: [MovieCast]?
    let crew: [MediaCrew]?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case cast = "cast"
        case crew = "crew"
    }
}

