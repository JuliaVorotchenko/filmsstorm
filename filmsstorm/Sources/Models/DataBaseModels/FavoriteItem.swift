//
//  File.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 20.07.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class FavoriteItem {
    let id: Int
    let posterImage: String
    let backgroundImage: String
    let name: String
    let originalName: String
    let releaseDate: String
    let rating: Double
    let overview: String
    
    init(id: Int, posterImage: String, backgroundImage: String, name: String, originalName: String, releaseDate: String, rating: Double, overview: String) {
        self.id = id
        self.posterImage = posterImage
        self.backgroundImage = backgroundImage
        self.name = name
        self.originalName = originalName
        self.releaseDate = releaseDate
        self.rating = rating
        self.overview = overview
    }
    
    init?(entity: FavoriteMovieEntity) {
        guard let posterData = entity.posterImage, let backgroundData = entity.backgroundImage else { return nil }
        
        self.id = Int(entity.id)
        self.posterImage = posterData
        self.backgroundImage = backgroundData
        self.name = entity.name ?? ""
        self.originalName = entity.originalName ?? ""
        self.releaseDate = entity.releaseDate ?? ""
        self.rating = entity.rating
        self.overview = entity.overview ?? ""
    }
    
    init?(entity: FavoriteShowEntity) {
        guard let posterData = entity.posterImage, let backgroundData = entity.backgroundImage else { return nil }
        
        self.id = Int(entity.id)
        self.posterImage = posterData
        self.backgroundImage = backgroundData
        self.name = entity.name ?? ""
        self.originalName = entity.originalName ?? ""
        self.releaseDate = entity.releaseDate ?? ""
        self.rating = entity.rating
        self.overview = entity.overview ?? ""
    }
    
    init?(entity: WatchlistedMovieEntity) {
        guard let posterData = entity.posterImage, let backgroundData = entity.backgroundImage else { return nil }
        
        self.id = Int(entity.id)
        self.posterImage = posterData
        self.backgroundImage = backgroundData
        self.name = entity.name ?? ""
        self.originalName = entity.originalName ?? ""
        self.releaseDate = entity.releaseDate ?? ""
        self.rating = entity.rating
        self.overview = entity.overview ?? ""
    }
    
    init?(entity: WatchlistedShowEntity) {
        guard let posterData = entity.posterImage, let backgroundData = entity.backgroundImage else { return nil }
        
        self.id = Int(entity.id)
        self.posterImage = posterData
        self.backgroundImage = backgroundData
        self.name = entity.name ?? ""
        self.originalName = entity.originalName ?? ""
        self.releaseDate = entity.releaseDate ?? ""
        self.rating = entity.rating
        self.overview = entity.overview ?? ""
    }
}
