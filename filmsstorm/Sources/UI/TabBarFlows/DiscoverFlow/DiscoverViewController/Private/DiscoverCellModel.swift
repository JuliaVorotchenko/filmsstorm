//
//  DiscoverCellModel.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 02.03.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

protocol MediaContainer {
    var posterImage: String? { get }
}

protocol Identifier {
    var idValue: Int { get }
}

protocol ConfigureModel: MediaContainer, Identifier {
    var mediaType: MediaType? { get }
    var name: String? { get }
    var voteAverage: Double? { get }
    var overview: String? { get }
    var releaseDate: String? { get }
    var backgroundImage: String? { get }
    var posterImage: String? { get }
}

enum MediaType: String, Codable {
    case movie
    case tv
}

struct DiscoverCellModel: ConfigureModel, Identifiable, Hashable {
    let id = UUID()
    let mediaType: MediaType?
    let idValue: Int
    let name: String?
    let voteAverage: Double?
    let overview: String?
    let releaseDate: String?
    let posterImage: String?
    let backgroundImage: String?
    let originalName: String?
    
    static func create(_ model: MovieListResult) -> Self {
        
        return .init(mediaType: .movie,
                     idValue: model.id,
                     name: model.title,
                     voteAverage: model.voteAverage,
                     overview: model.overview,
                     releaseDate: model.releaseDate,
                     posterImage: model.posterImage,
                     backgroundImage: model.backDropPath,
                     originalName: model.originalTitle)
    }
    
    static func create(_ model: ShowListResult) -> Self {
        
        return .init(mediaType: .tv,
                     idValue: model.id,
                     name: model.name,
                     voteAverage: model.voteAverage,
                     overview: model.overview,
                     releaseDate: model.firstAirDate,
                     posterImage: model.posterImage,
                     backgroundImage: model.backgroundImage,
                     originalName: model.originalName)
    }
    
    static func create(_ model: CombinedCastModel) -> Self {
        
        return .init(mediaType: model.mediaType,
                     idValue: model.id,
                     name: model.title,
                     voteAverage: model.voteAverage,
                     overview: model.overview,
                     releaseDate: model.releaseDate,
                     posterImage: model.posterImage,
                     backgroundImage: model.backgroundImage,
                     originalName: model.originalTitle)
    }
    
    static func create(_ model: FavoriteItem, mediaType: MediaType) -> Self {
        return .init(mediaType: mediaType,
                     idValue: model.id,
                     name: model.name,
                     voteAverage: model.rating,
                     overview: model.overview,
                     releaseDate: model.releaseDate,
                     posterImage: model.posterImage,
                     backgroundImage: model.backgroundImage,
                     originalName: model.originalName)
    }
    
}
