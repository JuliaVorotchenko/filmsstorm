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

    static func from(configure model: ConfigureModel) -> Self {
        return .init(id: model.id, name: model.name, originalName: "", voteAverage: model.voteAverage, overview: model.overview, releaseDate: model.releaseDate, posterImage: model.posterImage, backgroundImage: model.backgroundImage, mediaType: model.mediaType, genre: [.init(id: 1, name: "")])
    }

    static func create(_ model: MovieDetailsModel) -> Self {

        return .init(id: model.id, name: model.title, originalName: model.originalTitle,
                     voteAverage: model.voteAverage, overview: model.overview,
                     releaseDate: model.releaseDate, posterImage: model.posterImage,
                     backgroundImage: model.backgroundImage, mediaType: .movie,
                     genre: model.genres)

    }

    static func create(_ model: ShowDetailsModel) -> Self {

        return .init(id: model.id, name: model.name, originalName: model.originalName, voteAverage: model.voteAverage, overview: model.overview, releaseDate: model.firstAirDate, posterImage: model.posterImage, backgroundImage: model.backgroundImage, mediaType: .tv, genre: model.genres)
    }
}
