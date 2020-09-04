//
//  MovieVideosModel.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 11.03.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

struct ItemVideoModel: Codable, Hashable {
    let id: Int?
    let results: [VideoModel]
}

struct VideoModel: Codable, Hashable {
    let id: String?
    let language: String?
    let country: String?
    let key: String?
    let name: String?
    let site: String?
    let size: Int?
    let type: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case language = "iso_639_1"
        case country = "iso_3166_1"
        case key
        case name
        case site
        case size
        case type
    }
}
