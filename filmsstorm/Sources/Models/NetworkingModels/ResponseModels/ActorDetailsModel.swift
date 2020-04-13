//
//  ActorDetailsModel.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 12.04.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

struct ActorDetailsModel: Codable, Hashable {
    let id: Int?
    let birthday: String?
    let department: String?
    let deathday: String?
    let name: String?
    let knownAs: [String]?
    let gender: Int?
    let biography: String?
    let popularity: Double?
    let birthPlace: String?
    let profilePath: String?
    let adult: Bool?
    let imdbID: String?
    let homepage: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case birthday = "birthday"
        case department = "known_for_department"
        case deathday = "deathday"
        case name = "name"
        case knownAs = "also_known_as"
        case gender = "gender"
        case biography = "biography"
        case popularity = "popularity"
        case birthPlace = "place_of_birth"
        case profilePath = "profile_path"
        case adult = "adult"
        case imdbID = "imdb_id"
        case homepage = "homepage"
    }
    
}
