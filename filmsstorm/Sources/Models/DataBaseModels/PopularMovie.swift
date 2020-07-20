//
//  PopularMovie.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 20.07.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class PopularMovie {
    let id: String
    let mediaType: String
    let posterImage: UIImage
    
    init(id: String, mediaType: String, posterImage: UIImage) {
        self.id = id
        self.mediaType = mediaType
        self.posterImage = posterImage
    }
}
