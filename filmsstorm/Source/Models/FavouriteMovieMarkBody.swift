//
//  FavouriteMovieMarkBody.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 12.01.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

enum MediaType: String {
    case tv
    case movie
}

struct FavouriteMovieMarkBody: Codable {
    
    let mediaType: String
    let mediaID: Int
    let favourite: Bool
    
    enum CodingKeys: String, CodingKey {
        case mediaType = "media_type"
        case mediaID = "media_id"
        case favourite
    }
}
