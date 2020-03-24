//
//  MediaItemModel.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 17.03.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

protocol MediaItem: Codable, Hashable {
    var mediaType: MediaType { get }
      var id: Int { get }
      var poster: String? { get }
      var background: String { get }
      var name: String { get }
      var originalName: String { get }
      var rating: Double { get }
      var genre: [Genre] { get }
      var releaseDate: String { get }
      var overview: String { get }
}

struct MediaItemModel: MediaItem, Codable, Equatable, Hashable {
    let mediaType: MediaType
    let id: Int
    let poster: String?
    let background: String
    let name: String
    let originalName: String
    let rating: Double
    let genre: [Genre]
    let releaseDate: String
    let overview: String
    
    static func create(_ model: MovieDetailsModel) -> Self {
    
        return .init(mediaType: .movie,
                     id: model.id,
                     poster: model.posterPath,
                     background: model.backdropPath ?? model.posterPath,
                     name: model.title,
                     originalName: model.originalTitle,
                     rating: model.voteAverage,
                     genre: model.genres,
                     releaseDate: model.releaseDate,
                     overview: model.overview)
    }
        
    static func create(_ model: ShowDetailsModel) -> Self {
        return .init(mediaType: .tv,
                     id: model.id,
                     poster: model.posterPath,
                     background: model.backdropPath,
                     name: model.name,
                     originalName: model.originalName,
                     rating: model.voteAverage,
                     genre: model.genres,
                     releaseDate: model.firstAirDate,
                     overview: model.overview)
    }
}
