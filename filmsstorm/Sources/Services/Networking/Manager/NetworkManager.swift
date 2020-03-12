//
//  NetworkManager.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 08.01.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

class NetworkManager {
    // MARK: - Properties
    
    private let router = Router<APIEndPoint>(networkService: NetworkService())
    
    // MARK: - Networking methods
    
    func getToken(completion: @escaping (Result<RequestToken, NetworkError>) -> Void) {
        self.router.request(.auth(.createRequestToken), completion: completion)
    }
    
    func validateToken(with model: AuthRequestModel, completion: @escaping (Result<RequestToken, NetworkError>) -> Void) {
        self.router.request(.auth(.validateRequestToken(model)), completion: completion)
    }
    
    func createSession(with model: SessionRequestBody, completion: @escaping (Result<SessionID, NetworkError>) -> Void) {
        self.router.request(.auth(.createSession(model)), completion: completion)
    }
    
    func logout(completion: @escaping (Result<LogoutModel, NetworkError>) -> Void) {
        self.router.request(.auth(.logout(sessionID: KeyChainContainer.sessionID ?? "")), completion: completion)
    }
    
    func getUserDetails(completion: @escaping (Result<UserModel, NetworkError>) -> Void) {
        self.router.request(.account(.getAccountDetails(sessionID: KeyChainContainer.sessionID ?? "")),
                            completion: completion)
    }
    
    func getPopularMovies(completion: @escaping (Result<PopularMoviesModel, NetworkError>) -> Void) {
        self.router.request(.movie(.getMoviePopular), completion: completion)
    }
    
    func getUpcomingMovies(completion: @escaping (Result<UpcomingMoviesModel, NetworkError>) -> Void) {
        self.router.request(.movie(.getUpcoming), completion: completion)
    }
    
    func getPopularShows(completion: @escaping (Result<PopularShowsModel, NetworkError>) -> Void) {
        self.router.request(.tv(.getTVShowPopular), completion: completion)
    }
    
    func addToFavourites(with model: AddFavouritesRequestModel,
                         completion: @escaping (Result<AddToFavouritesModel, NetworkError>) -> Void) {
        self.router.request(.account(.addToFavourites(sessionID: KeyChainContainer.sessionID ?? "", model: model)),
                            completion: completion)
    }
    
    func addToWatchlist(with model: AddWatchListRequestModel,
                        completion: @escaping (Result<AddToFavouritesModel, NetworkError>) -> Void) {
        self.router.request(.account(.addToWatchList(sessionID: KeyChainContainer.sessionID ?? "", model: model)),
                            completion: completion)
    }
    
    func getFavoriteMovies(completion: @escaping (Result<FavouritesWatchlistMovies, NetworkError>) -> Void) {
        self.router.request(.account(.getFavouriteMovies(sessionID: KeyChainContainer.sessionID ?? "")), completion: completion)
    }
    
    func getFavoriteShows(completion: @escaping (Result<FavoritesWatchlistShows, NetworkError>) -> Void) {
        self.router.request(.account(.getFavouriteTVShows(sessionID: KeyChainContainer.sessionID ?? "")), completion: completion)
    }
    
    func getWathchListMovies(completion: @escaping (Result<FavouritesWatchlistMovies, NetworkError>) -> Void) {
        self.router.request(.account(.getMoviesWatchList(sessionID: KeyChainContainer.sessionID ?? "")), completion: completion)
    }
    
    func getWatchListShows(completion: @escaping (Result<FavoritesWatchlistShows, NetworkError>) -> Void) {
        self.router.request(.account(.getShowsWatchList(sessionID: KeyChainContainer.sessionID ?? "")), completion: completion)
    }
    
    func getMovieDetails(with model: DiscoverCellModel, completion: @escaping (Result<MovieDetailsModel, NetworkError>) -> Void) {
        self.router.request(.movie(.getMovieDetails(model: model)), completion: completion)
    }
    
    func getMovieSimilars(with model: DiscoverCellModel, completion: @escaping(Result<MovieSimilarsModel, NetworkError>) -> Void) {
        self.router.request(.movie(.getMovieSimilars(model: model)), completion: completion)
    }
    
    func getShowDetails(with model: DiscoverCellModel, completion: @escaping(Result<ShowDetailsModel, NetworkError>) -> Void) {
        self.router.request(.tv(.getTVShowDetails(model: model)), completion: completion)
    }
    
    func getShowSimilars(with model: DiscoverCellModel, completion: @escaping(Result<ShowSimilarsModel, NetworkError>) -> Void) {
        self.router.request(.tv(.getTVShowSimilar(model: model)), completion: completion)
    }
    
    func getMovieVideos(with model: DiscoverCellModel, completion: @escaping(Result<ItemVideoModel, NetworkError>) -> Void) {
        self.router.request(.movie(.getMovieVideos(model: model)), completion: completion)
    }
    
    func getShowVideos(with model: DiscoverCellModel, completion: @escaping(Result<ItemVideoModel, NetworkError>) -> Void) {
        self.router.request(.tv(.getTVShowVideos(model: model)), completion: completion)
    }
}
