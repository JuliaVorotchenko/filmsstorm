//
//  AddWatchListRequestModel.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 04.03.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

struct AddWatchListRequestModel: Codable {
    let mediaType: MediaType?
    let mediaID: Int
    let toWatchList: Bool
    
    enum CodingKeys: String, CodingKey {
        case mediaType = "media_type"
        case mediaID = "media_id"
        case toWatchList = "watchlist"
    }
    
    static func create(from model: MediaItemModel, isWatchlisted: Bool) -> Self {
        return .init(mediaType: model.mediaType,
                     mediaID: model.idValue,
                     toWatchList: isWatchlisted)
    }
}
