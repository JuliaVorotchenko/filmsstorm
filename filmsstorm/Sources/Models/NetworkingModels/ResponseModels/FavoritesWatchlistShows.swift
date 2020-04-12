//
//  GetFavoriteShowsModel.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 05.03.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

struct FavoritesWatchlistShows: Codable, Hashable {
    let page: Int?
       let results: [ShowListResult]
       let totalPages: Int?
       let totalResults: Int?
       
       enum CodingKeys: String, CodingKey {
           case page
           case results
           case totalPages = "total_pages"
           case totalResults = "total_results"
       }
}
