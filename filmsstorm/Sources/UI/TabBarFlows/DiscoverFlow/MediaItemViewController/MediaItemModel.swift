//
//  MediaItemModel.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 17.03.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

struct MediaItemModel: Codable, Equatable, Hashable {
    let mediaType: MediaType
    let id: Int
    let poster: String
    let background: String
    let name: String
    let originalName: String
    let rating: Double
    let genre: [Genre]
    let releaseDate: String
    
    
    static func create(_ model: MovieDetailsModel) -> Self {
        return .init(mediaType: .movie,
                     id: model.id,
                     poster: model.posterPath,
                     background: model.backDroppath,
                     name: model.title,
                     originalName: model.originalTitle,
                     rating: model.voteAverage,
                     genre: model.genres,
                     releaseDate: model.releaseDate)
    }
    
    static func create(_ model: ShowDetailsModel) -> Self {
        return .init(mediaType: .tv,
                     id: model.id[0],
                     poster: model.posterPath,
                     background: model.backdropPath,
                     name: model.name,
                     originalName: model.originalName,
                     rating: model.voteAverage,
                     genre: model.genres,
                     releaseDate: model.firstAirDate)
    }
}
