//
//  MovieDetailsModel.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 10.03.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

struct Genre: Codable, Hashable {
    let id: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}

struct ProducionCompany: Codable, Hashable {
    let id: Int
    let logo: String? = ""
    let name: String
    let originCountry: String
    
    enum CodingKeys: String, CodingKey {
       case name = "name"
       case id = "id"
       case logo = "logo_path"
       case originCountry = "origin_country"
    }
}

struct ProductionCountry: Codable, Hashable {
    let country: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case country = "iso_3166_1"
        case name = "name"
    }
}

struct Language: Codable, Hashable {
    let language: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case language = "iso_639_1"
        case name = "name"
    }
}

struct MovieDetailsModel: Codable, Hashable {
    let adult: Bool
    let backdropPath: String
    let collection: Collection?
    let budget: Int
    let genres: [Genre]
    let homepage: String?
    let id: Int
    let imdbID: String?
    let language: String?
    let originalTitle: String
    let overview: String
    let popularity: Double?
    let posterPath: String
    let productionCompanies: [ProducionCompany]
    let producionCounries: [ProductionCountry]
    let releaseDate: String
    let revenue: Int?
    let runtime: Int?
    let languages: [Language]
    let status: String
    let tagline: String?
    let title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case adult = "adult"
        case backdropPath = "backdrop_path"
        case collection = "belongs_to_collection"
        case budget = "budget"
        case genres = "genres"
        case homepage = "homepage"
        case id = "id"
        case imdbID = "imdb_id"
        case language = "original_language"
        case originalTitle = "original_title"
        case overview = "overview"
        case popularity = "popularity"
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case producionCounries = "production_countries"
        case releaseDate = "release_date"
        case revenue = "revenue"
        case runtime = "runtime"
        case languages = "spoken_languages"
        case status = "status"
        case tagline = "tagline"
        case title = "title"
        case video = "video"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

