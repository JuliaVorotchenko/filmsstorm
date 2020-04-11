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

protocol DetailsModel: Codable {
    var id: Int { get }
    var name: String? { get }
    var originalName: String? { get }
    var voteAverage: Double? { get }
    var overview: String? { get }
    var releaseDate: String? { get }
    var posterImage: String? { get }
    var backgroundImage: String? { get }
    var genres: [Genre] { get }
}

struct MediaItemModel: MediaItem {
    
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

    static func create(_ model: DetailsModel,
                       mediaType: MediaType,
                       isLiked: Bool,
                       isWatchlisted: Bool) -> Self {
        
        return .init(id: model.id,
                     name: model.name,
                     originalName: model.originalName ?? model.name ?? "N/A",
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
    
}


