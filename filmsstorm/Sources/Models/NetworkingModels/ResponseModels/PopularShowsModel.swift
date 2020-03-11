//
//  PopularShowsModel.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 25.02.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

struct PopularShowsModel: Codable, Hashable {
    let page: Int
    let results: [ShowListResult]
    let totalResults: Int
    let totalPages: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalResults = "total_results"
        case totalPages = "total_pages"
    }
}

struct ShowListResult: Codable, Hashable {
    let posterPath: String?
    let popularity: Double?
    let id: Int
    let backDropPath: String?
    let voteAverage: Double?
    let overview: String?
    let firstAirDate: String?
    let originCountry: [String]?
    let genreIDs: [Int]?
    let originalLanguage: String?
    let voteCount: Int?
    let name: String?
    let originalName: String?
    
    enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
        case popularity
        case id
        case backDropPath = "backdrop_path"
        case voteAverage = "vote_average"
        case overview
        case firstAirDate = "first_air_date"
        case originCountry = "origin_country"
        case genreIDs = "genre_ids"
        case originalLanguage = "original_language"
        case voteCount = "vote_count"
        case name
        case originalName = "original_name"
    }
}
