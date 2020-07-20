//
//  File.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 20.07.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class FavoriteItem {
    let id: String
    let posterImage: UIImage
    let backgroundImage: UIImage
    let name: String
    let originalName: String
    let releaseDate: String
    let rating: String
    let overview: String
    
    init(id: String, posterImage: UIImage, backgroundImage: UIImage, name: String, originalName: String, releaseDate: String, rating: String, overview: String) {
        self.id = id
        self.posterImage = posterImage
        self.backgroundImage = backgroundImage
        self.name = name
        self.originalName = originalName
        self.releaseDate = releaseDate
        self.rating = rating
        self.overview = overview
    }
}
