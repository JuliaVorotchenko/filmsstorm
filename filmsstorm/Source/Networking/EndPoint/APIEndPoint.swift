//
//  MovieEndPoint.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 08.01.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

enum APIEndPoint {
    case auth(AuthEndPoint)
    case account(AccountEndPoint)
    case discover(DiscoverEndPoint)
    case movie(MovieEndPoint)
    case people(PeopleEndPoint)
    case review(ReviewEndPoint)
    case search(SearchEndPoint)
    case tv(TVEndPoint)
    case tvSeason(TVSeasonEndPoint)
}

extension APIEndPoint: EndPointType {
    var httpMethod: HTTPMethod {
        switch self {
        case .auth(let model): return model.httpMethod
        case .account(let model): return model.httpMethod
        case .discover(let model): return model.httpMethod
        case .movie(let model): return model.httpMethod
        case .people(let model): return model.httpMethod
        case .review(let model): return model.httpMethod
        case .search(let model): return model.httpMethod
        case .tv(let model): return model.httpMethod
        case .tvSeason(let model): return model.httpMethod
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .auth(let model): return model.task
        case .account(let model): return model.task
        case .discover(let model): return model.task
        case .movie(let model): return model.task
        case .people(let model): return model.task
        case .review(let model): return model.task
        case .tv(let model): return model.task
        case .tvSeason(let model): return model.task
        case .search(let model): return model.task
        }
    }
    
    var base: String {
        return "https://api.themoviedb.org/3"
    }
    
    var baseURL: URL {
        guard let url = URL(string: base) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case .auth(let model): return model.path
        case .account(let model): return model.path
        case .discover(let model): return model.path
        case .movie(let model): return model.path
        case .people(let model): return model.path
        case .review(let model): return model.path
        case .search(let model): return model.path
        case .tv(let model): return model.path
        case .tvSeason(let model): return model.path
        }
    }
}
