//
//  AddWatchListRequestModel.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 04.03.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

struct AddWatchListRequestModel: Codable {
    let mediaType: String
    let mediaID: Int
    let toWatchList: Bool
    
    enum CodingKeys: String, CodingKey {
        case mediaType = "media_type"
        case mediaID = "media_id"
        case toWatchList = "watchlist"
    }
}
