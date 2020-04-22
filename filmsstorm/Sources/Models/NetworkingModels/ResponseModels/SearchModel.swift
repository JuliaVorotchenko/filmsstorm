//
//  SearchModel.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 01.03.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

struct SearchModel: Codable, Hashable {
    
    let page: Int
    let results: [MovieListReslutWitchMediaType]
    let totalResults: Int
    let totalPages: Int
    
    enum CodingKeys: String, CodingKey {
          case page
          case results
          case totalResults = "total_results"
          case totalPages = "total_pages"
      }
    
}

struct MovieSearchModel: Codable, Hashable {
    let page: Int
    let results: [MovieListResult]
    let totalResults: Int
    let totalPages: Int
    
    enum CodingKeys: String, CodingKey {
          case page
          case results
          case totalResults = "total_results"
          case totalPages = "total_pages"
      }
}

struct MovieListReslutWitchMediaType: Codable, Hashable {
    let posterImage: String?
    let adult: Bool?
    let overview: String?
    let releaseDate: String?
    let genreIDs: [Int]?
    let id: Int?
    let originalTitle: String?
    let originalLanguage: String?
    let title: String?
    let backgroundImage: String?
    let popularity: Double?
    let voteCount: Int?
    let video: Bool?
    let voteAverage: Double?
    let mediaType: String?
    
    enum CodingKeys: String, CodingKey {
        case posterImage = "poster_path"
        case adult
        case overview
        case releaseDate = "release_date"
        case genreIDs = "genre_ids"
        case id
        case originalTitle = "original_title"
        case originalLanguage = "original_language"
        case title
        case backgroundImage = "backdrop_path"
        case popularity
        case voteCount = "voteCount"
        case video
        case voteAverage = "vote_average"
        case mediaType = "media_type"
    }
}

struct ShowListResultWithMediaType: Codable, Hashable {
    let posterImage: String?
    let popularity: Double?
    let id: Int?
    let backgroundImage: String?
    let voteAverage: Double?
    let overview: String?
    let firstAirDate: String?
    let originCountry: [String]?
    let genreIDs: [Int]?
    let originalLanguage: String?
    let voteCount: Int?
    let name: String?
    let originalName: String?
    let mediaType: String?
    
    enum CodingKeys: String, CodingKey {
        case posterImage = "poster_path"
        case popularity
        case id
        case backgroundImage = "backdrop_path"
        case voteAverage = "vote_average"
        case overview
        case firstAirDate = "first_air_date"
        case originCountry = "origin_country"
        case genreIDs = "genre_ids"
        case originalLanguage = "original_language"
        case voteCount = "vote_count"
        case name
        case originalName = "original_name"
        case mediaType = "media_type"
    }
}

struct PersonListResult {
    let profilePath: String?
    let adult: Bool?
    let id: String?
    let mediaType: String?
    let knownFor: [MovieListReslutWitchMediaType]?
    
    enum CodingKeys: String, CodingKey {
        case profilePath = "profile_path"
        case adult
        case id
        case mediaType = "media_type"
        case knownFor = "known_for"
    }
}
