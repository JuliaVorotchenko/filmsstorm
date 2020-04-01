//
//  MovieEndPoint.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 15.01.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

extension APIEndPoint {
    enum MovieEndPoint: EndPointType {
        case getMovieCredits(model: Identifier)
        case getMovieDetails(model: Identifier)
        case getMovieImages(movieID: Int)
        case getMovieVideos(model: Identifier)
        case getMovieSimilars(model: Identifier)
        case getMovieReviews(movieID: Int)
        case rateMovie(movieID: Int, rateValue: Int)
        case deleteMovieRating(movieID: Int)
        case getMovieLatest
        case getMovieNowPlaying
        case getMoviePopular
        case getMovieTopRated
        case getUpcoming
        
        var path: String {
            switch self {
            case .getMovieCredits(let model):
                return "/movie/\(String(describing: model.id))/credits"
            case .getMovieDetails(let model):
                return "/movie/\(String(describing: model.id))"
            case .getMovieImages(let movieID):
                return "/movie/\(movieID)/images"
            case .getMovieVideos(let model):
                return "/movie/\(String(model.id))/videos"
            case .getMovieSimilars(let model):
                return "/movie/\(String(describing: model.id))/similar"
            case .getMovieReviews(let movieID):
                return "/movie/\(movieID)/reviews"
            case .rateMovie(let movieID, _):
                return "/movie/\(movieID)/rating"
            case .deleteMovieRating(let movieID):
                return "/movie/\(movieID)/rating"
            case .getMovieLatest:
                return "/movie/latest"
            case .getMovieNowPlaying:
                return "/movie/now_playing"
            case .getMoviePopular:
                return "/movie/popular"
            case .getMovieTopRated:
                return "/movie/top_rated"
            case .getUpcoming:
                return "/movie/upcoming"
            }
        }
        
        var httpMethod: HTTPMethod {
            switch self {
            case
            .getMovieCredits,
            .getMovieDetails,
            .getMovieImages,
            .getMovieVideos,
            .getMovieSimilars,
            .getMovieReviews,
            .getMovieLatest,
            .getMovieNowPlaying,
            .getMoviePopular,
            .getUpcoming,
            .getMovieTopRated:
                return .get
                
            case
            .rateMovie:
                return .post
                
            case
            .deleteMovieRating:
                return .delete
                
            }
        }
        
        var task: HTTPTask {
            switch self {
            case
            .getMovieLatest,
            .getMovieNowPlaying,
            .getMoviePopular,
            .getMovieTopRated,
            .getMovieImages,
            .getMovieReviews:
                return .requestParameters(bodyParameters: nil, urlParameters:  [Headers.apiKey: Headers.apiKeyValue])
                
            case
            .getMovieCredits(let model),
            .getMovieDetails(let model),
            .getMovieSimilars(let model),
            .getMovieVideos(let model):
                return .requestParameters(bodyParameters: nil, urlParameters: [Headers.apiKey: Headers.apiKeyValue,
                                                                               Headers.movieId: model.id])
                
            case .getUpcoming:
                return .requestParameters(bodyParameters: nil, urlParameters:  [Headers.apiKey: Headers.apiKeyValue,
                                                                                "language": "uk"])
                
            case .rateMovie(_, let rateValue):
                return .requestParametersAndHeaders(bodyParameters: ["value": rateValue],
                                                    urlParameters: [Headers.apiKey: Headers.apiKeyValue],
                                                    additionHeaders: [Headers.contentType: Headers.contentTypeValue])
            case .deleteMovieRating:
                return .requestParametersAndHeaders(bodyParameters: nil,
                                                    urlParameters: [Headers.apiKey: Headers.apiKeyValue],
                                                    additionHeaders: [Headers.contentType: Headers.contentTypeValue])
                
            }
        }
        
        var base: String {
            return "https://api.themoviedb.org/3"
        }
        
        var baseURL: URL {
            guard let url = URL(string: base) else { fatalError("baseURL could not be configured.")}
            return url
        }
    }
}
