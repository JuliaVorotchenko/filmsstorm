//
//  NetworkManager.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 08.01.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

protocol NetworkManagerDelegate: AuthorizationNetworkManager, ActorNetworkManager, MediaItemNetworkManager,
                                 DiscoverNetworkManager, ItemsNeworkManager, VideoPlayerNetworkManager, SearchNetworkManager,
                                 FavoritesNetworkManager, ProfileNetworkManager, MediaItemNetworkProocol {}

protocol MediaItemNetworkProocol: MediaItemNetworkManager, FavoritesNetworkManager {}

protocol AuthorizationNetworkManager {
    
    func getToken(completion: @escaping (Result<RequestToken, NetworkError>) -> Void)
    func validateToken(with model: AuthRequestModel,
                       completion: @escaping (Result<RequestToken, NetworkError>) -> Void)
    func createSession(with model: SessionRequestBody,
                       completion: @escaping (Result<SessionID, NetworkError>) -> Void)
}

protocol ActorNetworkManager {
   
    func getPersonDetails(with model: Identifier,
                          completion: @escaping(Result<ActorDetailsModel, NetworkError>) -> Void)
    func getPersonCredit(with model: Identifier,
                         completion: @escaping(Result<ActorCombinedCreditsModel, NetworkError>) -> Void)
}

protocol MediaItemNetworkManager {
    
    func getMovieDetails(with model: Identifier,
                         completion: @escaping (Result<MovieDetailsModel, NetworkError>) -> Void)
    func getShowDetails(with model: Identifier,
                        completion: @escaping(Result<ShowDetailsModel, NetworkError>) -> Void)
    func getMovieSimilars(with model: Identifier,
                          completion: @escaping(Result<MovieSimilarsModel, NetworkError>) -> Void)
    func getShowSimilars(with model: Identifier,
                         completion: @escaping(Result<ShowSimilarsModel, NetworkError>) -> Void)
    func getMovieCredits(with model: Identifier,
                         completion: @escaping(Result<MovieCreditsModel, NetworkError>) -> Void)
    func getShowCredits(with model: Identifier,
                        completion: @escaping(Result<ShowCreditsModel, NetworkError>) -> Void)
    func addToFavourites(with model: AddFavouritesRequestModel,
                         completion: @escaping (Result<SuccessModel, NetworkError>) -> Void)
    func addToWatchlist(with model: AddWatchListRequestModel,
                        completion: @escaping (Result<SuccessModel, NetworkError>) -> Void)
}

protocol DiscoverNetworkManager {
    
    func getUpcomingMovies(completion: @escaping (Result<UpcomingMoviesModel, NetworkError>) -> Void)
}

protocol ItemsNeworkManager {
    
    func getPopularMovies(completion: @escaping (Result<PopularMoviesModel, NetworkError>) -> Void)
    func getPopularShows(completion: @escaping (Result<PopularShowsModel, NetworkError>) -> Void)
}

protocol VideoPlayerNetworkManager {
    
    func getMovieVideos(with model: Identifier,
                        completion: @escaping(Result<ItemVideoModel, NetworkError>) -> Void)
    func getShowVideos(with model: Identifier,
                       completion: @escaping(Result<ItemVideoModel, NetworkError>) -> Void)
}

protocol SearchNetworkManager {
    
    func movieSearch(with query: String,
                     completion: @escaping(Result<MovieSearchModel, NetworkError>) -> Void)
    func showSearch(with query: String,
                    completion: @escaping(Result<ShowSearchModel, NetworkError>) -> Void)
}

protocol FavoritesNetworkManager {
    
    func getFavoriteMovies(completion: @escaping (Result<FavouritesWatchlistMovies, NetworkError>) -> Void)
    func getFavoriteShows(completion: @escaping (Result<FavoritesWatchlistShows, NetworkError>) -> Void)
    func getWathchListMovies(completion: @escaping (Result<FavouritesWatchlistMovies, NetworkError>) -> Void)
    func getWatchListShows(completion: @escaping (Result<FavoritesWatchlistShows, NetworkError>) -> Void)
}

protocol ProfileNetworkManager {
    
    func logout(completion: @escaping (Result<LogoutModel, NetworkError>) -> Void)
    func getUserDetails(completion: @escaping (Result<UserModel, NetworkError>) -> Void)
}

class NetworkManager: NetworkManagerDelegate {
    
    // MARK: - Properties
    
    private let router = Router<APIEndPoint>(networkService: NetworkService())
    
    // MARK: - Networking methods
    // MARK: - Authorization requests
    
    func getToken(completion: @escaping (Result<RequestToken, NetworkError>) -> Void) {
        self.router.request(.auth(.createRequestToken), completion: completion)
    }
    
    func validateToken(with model: AuthRequestModel,
                       completion: @escaping (Result<RequestToken, NetworkError>) -> Void) {
        self.router.request(.auth(.validateRequestToken(model)), completion: completion)
    }
    
    func createSession(with model: SessionRequestBody,
                       completion: @escaping (Result<SessionID, NetworkError>) -> Void) {
        self.router.request(.auth(.createSession(model)), completion: completion)
    }
    
    func logout(completion: @escaping (Result<LogoutModel, NetworkError>) -> Void) {
        self.router.request(.auth(.logout(sessionID: KeyChainContainer.sessionID ?? "")), completion: completion)
    }
    
    func getUserDetails(completion: @escaping (Result<UserModel, NetworkError>) -> Void) {
        self.router.request(.account(.getAccountDetails(sessionID: KeyChainContainer.sessionID ?? "")),
                            completion: completion)
    }
    
    // MARK: - Popular media reequests
    
    func getPopularMovies(completion: @escaping (Result<PopularMoviesModel, NetworkError>) -> Void) {
        self.router.request(.movie(.getMoviePopular), completion: completion)
    }
    
    func getUpcomingMovies(completion: @escaping (Result<UpcomingMoviesModel, NetworkError>) -> Void) {
        self.router.request(.movie(.getUpcoming), completion: completion)
    }
    
    func getPopularShows(completion: @escaping (Result<PopularShowsModel, NetworkError>) -> Void) {
        self.router.request(.tv(.getTVShowPopular), completion: completion)
    }
    
    // MARK: - Lists update requests
    
    func addToFavourites(with model: AddFavouritesRequestModel,
                         completion: @escaping (Result<SuccessModel, NetworkError>) -> Void) {
        self.router.request(.account(.addToFavourites(sessionID: KeyChainContainer.sessionID ?? "", model: model)),
                            completion: completion)
    }
    
    func addToWatchlist(with model: AddWatchListRequestModel,
                        completion: @escaping (Result<SuccessModel, NetworkError>) -> Void) {
        self.router.request(.account(.addToWatchList(sessionID: KeyChainContainer.sessionID ?? "", model: model)),
                            completion: completion)
    }
    
    // MARK: - Favorites & Watchlists
    
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
    
    // MARK: - Media details & similars
    
    func getMovieDetails(with model: Identifier,
                         completion: @escaping (Result<MovieDetailsModel, NetworkError>) -> Void) {
        self.router.request(.movie(.getMovieDetails(model: model)), completion: completion)
    }
    
    func getMovieSimilars(with model: Identifier,
                          completion: @escaping(Result<MovieSimilarsModel, NetworkError>) -> Void) {
        self.router.request(.movie(.getMovieSimilars(model: model)), completion: completion)
    }
    
    func getShowDetails(with model: Identifier,
                        completion: @escaping(Result<ShowDetailsModel, NetworkError>) -> Void) {
        self.router.request(.tv(.getTVShowDetails(model: model)), completion: completion)
    }
    
    func getShowSimilars(with model: Identifier,
                         completion: @escaping(Result<ShowSimilarsModel, NetworkError>) -> Void) {
        self.router.request(.tv(.getTVShowSimilar(model: model)), completion: completion)
    }
    
    // MARK: - Media Videos
    
    func getMovieVideos(with model: Identifier,
                        completion: @escaping(Result<ItemVideoModel, NetworkError>) -> Void) {
        self.router.request(.movie(.getMovieVideos(model: model)), completion: completion)
    }
    
    func getShowVideos(with model: Identifier,
                       completion: @escaping(Result<ItemVideoModel, NetworkError>) -> Void) {
        self.router.request(.tv(.getTVShowVideos(model: model)), completion: completion)
    }
    
    // MARK: - Media credits
    
    func getMovieCredits(with model: Identifier,
                         completion: @escaping(Result<MovieCreditsModel, NetworkError>) -> Void) {
        self.router.request(.movie(.getMovieCredits(model: model)), completion: completion)
    }
    
    func getShowCredits(with model: Identifier,
                        completion: @escaping(Result<ShowCreditsModel, NetworkError>) -> Void) {
        self.router.request(.tv(.getTVShowCredits(model: model)), completion: completion)
    }
    
    // MARK: - Actor requests
    
    func getPersonDetails(with model: Identifier,
                          completion: @escaping(Result<ActorDetailsModel, NetworkError>) -> Void) {
        self.router.request(.people(.getPeopleDetails(personID: model)), completion: completion)
    }
    
    func getPersonCredit(with model: Identifier,
                         completion: @escaping(Result<ActorCombinedCreditsModel, NetworkError>) -> Void) {
        self.router.request(.people(.getCombinedCredit(personID: model)), completion: completion)
    }
    
    // MARK: - Search Requests
    
    func movieSearch(with query: String,
                     completion: @escaping(Result<MovieSearchModel, NetworkError>) -> Void) {
        self.router.request(.search(.movieSearch(query)), completion: completion)
    }
    
    func showSearch(with query: String,
                    completion: @escaping(Result<ShowSearchModel, NetworkError>) -> Void) {
        self.router.request(.search(.tvSearch(query)), completion: completion)
    }
}
