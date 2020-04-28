//
//  MultiSearchModel.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 21.04.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

struct MultiSearchModel: Codable, Hashable {
    let page: Int?
    let totalResults: Int?
    let totalPages: Int?
    let results: [MultiSearchResult]?
    
    enum CodingKeys: String, CodingKey {
        case page = "page"
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case results = "results"
    }
}

struct MultiSearchResult: Codable, Hashable {
     let originalName: String?
       let genreIDS: [Int]?
       let mediaType: MediaType?
       let name: String?
       let popularity: Double
       let originCountry: [String]?
       let voteCount: Int?
       let firstAirDate: String?
       let backgroundImage: String?
       let originalLanguage: String?
       let id: Int?
       let voteAverage: Int?
       let overview: String?
       let posterImage: String?
       let knownForDepartment: String?
       let knownFor: [KnownForResponse]?
       let profilePath: String?
       let gender: Int?
       let adult: Bool?
       let video: Bool?
       let originalTitle: String?
       let title: String?
       let releaseDate: String?

       enum CodingKeys: String, CodingKey {
           case originalName = "original_name"
           case genreIDS = "genre_ids"
           case mediaType = "media_type"
           case name = "name"
           case popularity = "popularity"
           case originCountry = "origin_country"
           case voteCount = "vote_count"
           case firstAirDate = "first_air_date"
           case backgroundImage = "backdrop_path"
           case originalLanguage = "original_language"
           case id = "id"
           case voteAverage = "vote_average"
           case overview = "overview"
           case posterImage = "poster_path"
           case knownForDepartment = "known_for_department"
           case knownFor = "known_for"
           case profilePath = "profile_path"
           case gender = "gender"
           case adult = "adult"
           case video = "video"
           case originalTitle = "original_title"
           case title = "title"
           case releaseDate = "release_date"
    }
}

struct KnownForResponse: Codable, Hashable {
     let releaseDate: String?
     let voteCount: Int?
     let video: Bool?
     let mediaType: String?
     let id: Int?
     let voteAverage: Double?
     let title: String?
     let originalLanguage: String?
     let originalTitle: String?
     let genreIDS: [Int]?
     let adult: Bool?
     let overview: String?
     let posterPath: String?
     let backdropPath: String?

     enum CodingKeys: String, CodingKey {
         case releaseDate = "release_date"
         case voteCount = "vote_count"
         case video = "video"
         case mediaType = "media_type"
         case id = "id"
         case voteAverage = "vote_average"
         case title = "title"
         case originalLanguage = "original_language"
         case originalTitle = "original_title"
         case genreIDS = "genre_ids"
         case adult = "adult"
         case overview = "overview"
         case posterPath = "poster_path"
         case backdropPath = "backdrop_path"
       }
}
