//
//  ShowDetailsModel.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 10.03.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

struct Creator: Codable, Hashable {
    let id: Int?
    let creditId: String?
    let name: String?
    let gender: Int?
    let profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case creditId = "credit_id"
        case name = "name"
        case gender = "gender"
        case profilePath = "profile_path"
    }
}

struct Episode: Codable, Hashable {
    let airDate: String?
    let episodeNumber: Int?
    let id: Int?
    let name: String?
    let overview: String?
    let productionCode: String?
    let seasonNumber: Int?
    let showId: Int?
    let stillPath: String?
    let voteAverage: Double?
    let voteCount: Int?
    
    enum CodingKeys: String, CodingKey {
       case airDate = "air_date"
       case episodeNumber = "episode_number"
       case id = "id"
       case name = "name"
       case overview = "overview"
       case productionCode = "production_code"
       case seasonNumber = "season_number"
       case showId = "show_id"
       case stillPath = "still_path"
       case voteAverage = "vote_average"
       case voteCount = "vote_count"
    }
}

struct Network: Codable, Hashable {
    let name: String?
    let id: Int?
    let logoPath: String?
    let originCountry: String?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case id = "id"
        case logoPath = "logo_path"
        case originCountry = "origin_country"
    }
}

struct Season: Codable, Hashable {
    let airDate: String?
    let episodeCount: Int?
    let id: Int?
    let name: String?
    let overview: String?
    let posterPath: String?
    let seasonNumber: Int?
    
    enum CodingKeys: String, CodingKey {
       case airDate = "air_date"
       case episodeCount = "episode_count"
       case id = "id"
       case name = "name"
       case overview = "overview"
       case posterPath = "poster_path"
       case seasonNumber = "season_number"
    }
}

struct ShowDetailsModel: Codable, Hashable {
    let backgroundImage: String
    let creator: [Creator]?
    let runTime: [Int]?
    let firstAirDate: String
    let genres: [Genre]
    let homepage: String?
    let id: Int
    let inProduction: Bool?
    let languages: [String]?
    let lastAirDate: String?
    let lastEpisodeToAir: Episode?
    let name: String
    let nextEpisodeToAir: Episode?
    let networks: [Network]?
    let episodesNumber: Int?
    let seasonsNumber: Int?
    let originCountry: [String]?
    let originalLanguage: String?
    let originalName: String
    let overview: String
    let popularity: Double?
    let posterImage: String
    let companies: [ProducionCompany]
    let seasons: [Season]?
    let status: String?
    let type: String?
    let voteAverage: Double
    let voteCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case backgroundImage = "backdrop_path"
        case creator = "created_by"
        case runTime = "episode_run_time"
        case firstAirDate = "first_air_date"
        case genres = "genres"
        case homepage = "homepage"
        case id = "id"
        case inProduction = "in_production"
        case languages = "languages"
        case lastAirDate = "last_air_date"
        case lastEpisodeToAir = "last_episode_to_air"
        case name = "name"
        case nextEpisodeToAir = "next_episode_to_air"
        case networks = "networks"
        case episodesNumber = "number_of_episodes"
        case seasonsNumber = "number_of_seasons"
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case originalName = "original_name"
        case overview = "overview"
        case popularity = "popularity"
        case posterImage = "poster_path"
        case companies = "production_companies"
        case seasons = "seasons"
        case status = "status"
        case type = "type"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
