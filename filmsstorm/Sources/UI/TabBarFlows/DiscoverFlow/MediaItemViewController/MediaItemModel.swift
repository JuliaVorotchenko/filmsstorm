//
//  MediaItemModel.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 17.03.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

protocol MediaItem: ConfigureModel, Codable, Hashable {
    
    var originalName: String { get }
    var genre: [Genre] { get }
}

struct MediaItemModel: MediaItem, Codable {
    
    let id: Int
    let name: String?
    let originalName: String
    let voteAverage: Double?
    let overview: String?
    let releaseDate: String?
    let posterImage: String?
    let backgroundImage: String?
    let mediaType: MediaType
    let genre: [Genre]
    let isLiked: Bool?
    let isWatchListed: Bool?

    static func update(_ model: Self, isLiked: Bool = false, isWatchlisted: Bool = false) -> Self {
        return .init(id: model.id,
                     name: model.name,
                     originalName: model.originalName,
                     voteAverage: model.voteAverage,
                     overview: model.overview,
                     releaseDate: model.releaseDate,
                     posterImage: model.posterImage,
                     backgroundImage: model.backgroundImage,
                     mediaType: .movie,
                     genre: model.genre,
                     isLiked: isLiked,
                     isWatchListed: isWatchlisted)
    }

    static func create(_ model: MovieDetailsModel, isLiked: Bool = false, isWatchlisted: Bool = false) -> Self {
        
        return .init(id: model.id,
                     name: model.title,
                     originalName: model.originalTitle,
                     voteAverage: model.voteAverage,
                     overview: model.overview,
                     releaseDate: model.releaseDate,
                     posterImage: model.posterImage,
                     backgroundImage: model.backgroundImage ?? model.posterImage,
                     mediaType: .movie,
                     genre: model.genres,
                     isLiked: isLiked,
                     isWatchListed: isWatchlisted)
        
    }
    
    static func create(_ model: ShowDetailsModel, isLiked: Bool = false, isWatchlisted: Bool = false) -> Self {
        
        return .init(id: model.id,
                     name: model.name,
                     originalName: model.originalName ?? model.name,
                     voteAverage: model.voteAverage,
                     overview: model.overview,
                     releaseDate: model.firstAirDate,
                     posterImage: model.posterImage,
                     backgroundImage: model.backgroundImage ?? model.posterImage,
                     mediaType: .tv,
                     genre: model.genres,
                     isLiked: isLiked,
                     isWatchListed: isWatchlisted)
    }
}
