//
//  File.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 09.01.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//


struct Hash: Codable {
       let hash: String?
   }
   
   struct Avatar: Codable {
       let gravatar: Hash?
   }

struct UserModel: Codable {
   
    let avatar: Avatar?
    let id: Int?
    let language: String?
    let country: String?
    let name: String
    let isIncludeAdultContent: Bool?
    let username: String?
    
    enum CodingKeys: String, CodingKey {
        case avatar
        case id
        case language = "iso_639_1"
        case country = "iso_3166_1"
        case name
        case isIncludeAdultContent = "include_adult"
        case username
    }
}
