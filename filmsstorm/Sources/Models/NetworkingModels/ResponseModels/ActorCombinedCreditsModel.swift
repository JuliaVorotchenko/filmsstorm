//
//  ActorCombinedCreditsModel.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 12.04.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

struct ActorCombinedCreditsModel: Codable, Identifiable {
    let id: Int?
    let cast: [CombinedCastModel]?
    let crew: [CombinedCrewModel]?
}

struct CombinedCastModel: Codable, Hashable {
    
    let id: Int
    let character: String?
    let originalTitle: String?
    let overview: String?
    let voteCount: Int?
    let video: Bool?
    let mediaType: MediaType?
    let posterImage: String?
    let backgroundImage: String?
    let popularity: Double?
    let title: String?
    let language: String?
    let genreIDs: [Int]?
    let voteAverage: Double?
    let adult: Bool?
    let releaseDate: String?
    let creditID: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case character = "character"
        case originalTitle = "original_title"
        case overview = "overview"
        case voteCount = "vote_count"
        case video = "video"
        case mediaType = "media_type"
        case posterImage = "poster_path"
        case backgroundImage = "backdrop_path"
        case popularity = "popularity"
        case title = "title"
        case language = "original_language"
        case genreIDs = "genre_ids"
        case voteAverage = "vote_average"
        case adult = "adult"
        case releaseDate = "release_date"
        case creditID = "credit_id"
    }
    
}

struct CombinedCrewModel: Codable, Hashable {
    let id: Int?
    let department: String?
    let language: String?
    let originalName: String?
    let job: String?
    let overview: String?
    let voteCount: Int?
    let video: Bool?
    let mediaType: String?
    let posterImage: String?
    let backgroundImage: String?
    let name: String?
    let popularity: Double?
    let genreIDs: [Int]?
    let voteAverage: Double?
    let adult: Bool?
    let releaseDate: String?
    let creditID: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case department = "department"
        case language = "original_language"
        case job = "job"
        case overview = "overview"
        case originalName = "original_name"
        case voteCount = "vote_count"
        case name = "title"
        case mediaType = "media_type"
        case popularity = "popularity"
        case creditID = "credit_id"
        case backgroundImage = "backdrop_path"
        case voteAverage = "vote_average"
        case genreIDs = "genre_ids"
        case posterImage = "poster_path"
        case video = "video"
        case releaseDate = "release_date"
        case adult = "adult"
    }
}
