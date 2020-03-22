//
//  CollectionModel.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 10.03.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

struct CollectionPart: Codable, Hashable {
    let adult: Bool
    let backdropPath: String?
    let genres: [Int]
    let id: Int
    let language: String
    let originalTitle: String
    let overview: String
    let releaseDate: String
    let posterPath: String
    let popularity: Double
    let title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
    
    enum CodingKeys: String, CodingKey {
        case adult = "adult"
        case backdropPath = "backdrop_path"
        case genres = "genre_ids"
        case id = "id"
        case language = "original_language"
        case originalTitle = "original_title"
        case overview = "overview"
        case releaseDate = "release_date"
        case posterPath = "poster_path"
        case popularity = "popularity"
        case title = "title"
        case video = "video"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

struct Collection: Codable, Hashable {
    let id: Int
    let name: String
    let posterPath: String? = nil
    let backdropPath: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
       
    }
}
