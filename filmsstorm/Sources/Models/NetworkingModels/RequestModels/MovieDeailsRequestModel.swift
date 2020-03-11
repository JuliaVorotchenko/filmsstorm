//
//  File.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 10.03.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

struct MovieDeailsRequestModel: Codable {
    let id: Int
    enum CodingKeys: String, CodingKey {
        case id = "movie_id"
    }
}
