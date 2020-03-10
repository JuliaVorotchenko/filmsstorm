//
//  MovieDetailsModel.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 10.03.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation
 
struct Genre: Codable, Hashable {
    let id: Int?
    let name: String?
}

struct ProductionCompany: Codable, Hashable {
    let name: String?
    let id: Int?
    let logoPath: String?
    let originCountry: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case id
        case logoPath = "logo_path"
        case originCountry = "origin_country"
    }
}

struct ProductionCountry: Codable, Hashable {
    let iso: String?
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case iso = "iso_3166_1"
        case name
    }
}

struct SpokenLanguage: Codable, Hashable {
    let iso: String?
    let name: String?
    
    enum CodingKeys: String, CodingKey {
           case iso = "iso_639_1"
           case name
       }
}

struct MovieDetailsModel: Codable, Hashable {
    let adult: Bool?
    let backDroppath: String?
    let collection: Collection?
    let budget: Int?
    let genres: [Genre]?
    let homepage: String?
    let id: Int?
    let imdbId: String?
    let originalLanguage: String?
    let originalTitle: String?
    let overview: String?
    let popularuty: Double?
    let posterPath: String?
    let companies: [ProductionCompany]?
    let countries: [ProductionCountry]?
    let releaseDate: String?
    let revenue: Int?
    let runtime: Int?
    let languages: [SpokenLanguage]?
    let status: String?
    let tagline: String?
    let title: String?
    let voteAverage: Double?
    let voteCount: Int?
    
    enum CodingKeys: String, CodingKey {
       case adult
       case backDroppath = "backdrop_path"
       case collection
       case budget
       case genres
       case homepage
       case id
       case imdbId = "imdb_id"
       case originalLanguage = "original_language"
       case originalTitle = "original_title"
       case overview
       case popularuty
       case posterPath = "poster_path"
       case companies = "production_companies"
       case countries = "production_countries"
       case releaseDate = "release_date"
       case revenue
       case runtime
       case languages = "spoken_languages"
       case status
       case tagline
       case title
       case voteAverage = "vote_average"
       case voteCount = "vote_count"
    }
    
}
