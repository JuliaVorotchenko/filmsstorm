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
    var id: Int { get }
}

protocol ConfigureModel: MediaContainer, Identifier {
    var mediaType: MediaType { get }
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

struct DiscoverCellModel: ConfigureModel, Codable, Hashable {

    let mediaType: MediaType
    let id: Int
    let name: String?
    let voteAverage: Double?
    let overview: String?
    let releaseDate: String?
    let posterImage: String?
    let backgroundImage: String?
    
    static func create(_ model: MovieListResult) -> Self {
    
        return .init(mediaType: .movie, id: model.id, name: model.title,
                     voteAverage: model.voteAverage,
                     overview: model.overview,
                     releaseDate: model.releaseDate,
                     posterImage: model.posterImage,
                     backgroundImage: model.backDropPath)
    }
    
    static func create(_ model: ShowListResult) -> Self {
       
        return .init(mediaType: .tv, id: model.id, name: model.name,
                     voteAverage: model.voteAverage,
                     overview: model.overview,
                     releaseDate: model.firstAirDate,
                     posterImage: model.posterImage,
                     backgroundImage: model.backgroundImage)
    }
}
