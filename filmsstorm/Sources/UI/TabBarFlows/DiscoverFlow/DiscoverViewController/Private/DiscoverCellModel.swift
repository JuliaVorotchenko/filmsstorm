//
//  DiscoverCellModel.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 02.03.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

protocol ConfigureModel {
    var mediaType: MediaType { get }
    var id: Int? { get }
    var name: String? { get }
    var voteAverage: Double? { get }
    var overview: String? { get }
    var releaseDate: String? { get }
    var posterPath: String? { get }
    var backDropPath: String? { get }
}

enum MediaType: String {
    case movie
    case tv
}

struct DiscoverCellModel: ConfigureModel, Equatable, Hashable {
    let mediaType: MediaType
    let id: Int?
    let name: String?
    let voteAverage: Double?
    let overview: String?
    let releaseDate: String?
    let posterPath: String?
    let backDropPath: String?
    
    static func create(_ model: MovieListResult) -> Self {
        return .init(mediaType: .movie, id: model.id, name: model.title, voteAverage: model.voteAverage,
                     overview: model.overview, releaseDate: model.releaseDate,
                     posterPath: model.posterPath, backDropPath: model.backDropPath)
    }
    
    static func create(_ model: ShowListResult) -> Self {
        return .init(mediaType: .tv, id: model.id, name: model.name, voteAverage: model.voteAverage,
                     overview: model.overview, releaseDate: model.firstAirDate, posterPath: model.posterPath, backDropPath: model.backDropPath)
    }
}
