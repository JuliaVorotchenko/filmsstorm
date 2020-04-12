//
//  AddFavouritesModel.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 04.03.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

struct AddFavouritesRequestModel: Codable {
    let mediaType: String
    let mediaID: Int
    let isFavourite: Bool
    
    enum CodingKeys: String, CodingKey {
        case mediaType = "media_type"
        case mediaID = "media_id"
        case isFavourite = "favorite"
    }
    
    static func create(from model: MediaItemModel, isFavorite: Bool) -> Self {
        return .init(mediaType: model.mediaType.rawValue,
                     mediaID: model.id,
                     isFavourite: isFavorite)
    }
}
