//
//  ActorModel.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 24.03.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

protocol Actor: Codable, Identifier {
    var mediaType: MediaType { get }
    var character: String? { get }
    var actorName: String? { get }
    var actorImage: String? { get }
}

struct ActorModel: Actor, Codable, Hashable, Equatable {
    
    let idValue: Int
    let mediaType: MediaType
    let character: String?
    let actorName: String?
    let actorImage: String?
    
    static func create(_ model: MovieCast) -> Self {
        
        return .init(idValue: model.id,
                     mediaType: .movie,
                     character: model.character,
                     actorName: model.name,
                     actorImage: model.profilePath)
    }
    
    static func create(_ model: ShowCast) -> Self {
        
        return .init(idValue: model.id,
                     mediaType: .tv,
                     character: model.character,
                     actorName: model.name,
                     actorImage: model.profilePath)
    }
}
