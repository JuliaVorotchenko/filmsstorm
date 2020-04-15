//
//  MediaItemPresenter.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 25.02.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

enum MediaItemEvent: EventProtocol {
    case back
    case onMediaItem(DiscoverCellModel)
    case onPlay(MediaItemModel)
    case onActor(ActorModel)
    case error(AppError)
}

protocol MediaItemPresenter: Presenter {
    var showActivity: Handler<ActivityState>? { get set }
    var itemModel: ConfigureModel { get }
    
    func onBack()
    func onSimilarsItem(with model: DiscoverCellModel)
    func onPlay(item: MediaItemModel)
    func onActor(actor: ActorModel)
    func updateFavorites(for item: MediaItemModel, isFavorite: Bool)
    func updateWatchlist(for item: MediaItemModel, isWatchlisted: Bool) 
    
    func getItemDetails(_ completion: ((MediaItemModel) -> Void)?)
    func getItemSimilars(_ completion: (([DiscoverCellModel]) -> Void)?)
    func getItemCast(_ completion: (([ActorModel]) -> Void)?)
}

class MediaItemPresenterImpl: MediaItemPresenter {
    
    // MARK: - Properties
    
    let eventHandler: Handler<MediaItemEvent>?
    var showActivity: Handler<ActivityState>?
    private let networking: NetworkManager
    let itemModel: ConfigureModel
    
    private var mediaModel: MediaItemModel?
    
    // MARK: - Init and deinit
    
    init(networking: NetworkManager, event: Handler<MediaItemEvent>?, itemModel: ConfigureModel) {
        self.networking = networking
        self.eventHandler = event
        self.itemModel = itemModel
        self.getLists()
    }
    
    // MARK: - Networking Methods
   
    func getItemDetails(_ completion: ((MediaItemModel) -> Void)?) {
        switch self.itemModel.mediaType ?? .movie {
        case .movie:
            self.networking.getMovieDetails(with: self.itemModel) { [weak self] result in
                switch result {
                case .success(let detailsModel):
                    self.map { completion?($0.createMediaItem(detailsModel))}
                case .failure(let error):
                    self?.eventHandler?(.error(.networkingError(error)))
                }
            }
        case .tv:
            self.networking.getShowDetails(with: self.itemModel) { [weak self] result in
                switch result {
                case .success(let detailsModel):
                    self.map { completion?($0.createMediaItem(detailsModel))}
                case .failure(let error):
                    self?.eventHandler?(.error(.networkingError(error)))
                }
            }
        }
    }
    
    private func createMediaItem(_ model: DetailsModel) -> MediaItemModel {
        let isLiked = self.itemModel.mediaType == .movie
            ? UserMoviesContainer.favoritesIDs.contains(model.id)
            :UserShowsContainer.favoritesIDs.contains(model.id)
        let isWatchlisted = self.itemModel.mediaType == .movie
            ? UserMoviesContainer.watchlistIDs.contains(model.id)
            : UserShowsContainer.watchlistIDs.contains(model.id)
        
        return .create(model,
                       mediaType: self.itemModel.mediaType  ?? .movie,
                       isLiked: isLiked,
                       isWatchlisted: isWatchlisted)
    }
    
    //item cast
    
    func getItemCast(_ completion: (([ActorModel]) -> Void)?) {
        switch self.itemModel.mediaType ?? .movie {
        case .movie:
            self.networking.getMovieCredits(with: self.itemModel) { [weak self] result in
                switch result {
                case .success(let creditsModel):
                    creditsModel.cast.map { completion?($0.map(ActorModel.create)) }
                case .failure(let error):
                    self?.eventHandler?(.error(.networkingError(error)))
                }
            }
            
        case .tv:
            self.networking.getShowCredits(with: self.itemModel) { [weak self] result in
                switch result {
                case .success(let creditsModel):
                    guard let movieCast = creditsModel.cast else { return }
                    completion?(movieCast.map(ActorModel.create))
                case .failure(let error):
                    self?.eventHandler?(.error(.networkingError(error)))
                }
            }
        }
    }
    
    //item similars
    
    func getItemSimilars(_ completion: (([DiscoverCellModel]) -> Void)?) {
        switch self.itemModel.mediaType ?? .movie {
        case .movie:
            self.networking.getMovieSimilars(with: self.itemModel) { result in
                switch result {
                case .success(let similarsModel):
                    guard let results = similarsModel.results else { return }
                    
                    completion?(results.map(DiscoverCellModel.create))
                case .failure(let error):
                    self.eventHandler?(.error(.networkingError(error)))
                }
            }
        case .tv:
            self.networking.getShowSimilars(with: self.itemModel) { result in
                switch result {
                case.success(let similarsModel):
                    guard let results = similarsModel.results else { return }
                    print(#function, results)
                    completion?(results.map(DiscoverCellModel.create))
                case .failure(let error):
                    self.eventHandler?(.error(.networkingError(error)))
                }
            }
        }
    }
    
    //Update Favorites
    
    func updateFavorites(for item: MediaItemModel, isFavorite: Bool) {
        let model = AddFavouritesRequestModel.create(from: item, isFavorite: isFavorite)
        self.networking.addToFavourites(with: model) { [weak self] result in
            switch result {
            case .success:
                isFavorite ? self?.addFavoriteStorage(item: item): self?.removeFavoriteStorage(item: item)
            case .failure(let error):
                self?.eventHandler?(.error(.networkingError(error)))
            }
        }
    }
    
    private func addFavoriteStorage(item: MediaItemModel) {
        switch self.itemModel.mediaType ?? .movie {
        case .movie:
            UserMoviesContainer.favoritesIDs.append(item.idValue)
        case .tv:
            UserShowsContainer.favoritesIDs.append(item.idValue)
        }
    }
    
    private func removeFavoriteStorage(item: MediaItemModel) {
        switch self.itemModel.mediaType ?? .movie {
        case .movie:
            UserMoviesContainer.favoritesIDs = UserMoviesContainer.favoritesIDs.filter { $0 != item.idValue }
        case .tv:
            UserShowsContainer.favoritesIDs = UserShowsContainer.favoritesIDs.filter { $0 != item.idValue }
        }
    }
    
    // Update watchlists
    
    func updateWatchlist(for item: MediaItemModel, isWatchlisted: Bool) {
        let model = AddWatchListRequestModel.create(from: item, isWatchlisted: isWatchlisted)
        self.networking.addToWatchlist(with: model) { [weak self] result in
            switch result {
            case .success:
                isWatchlisted ? self?.addWatchlistStorage(item: item): self?.removeWatchlistStorage(item: item)
            case .failure(let error):
                self?.eventHandler?(.error(.networkingError(error)))
            }
        }
    }
    
    private func addWatchlistStorage(item: MediaItemModel) {
        switch self.itemModel.mediaType {
        case .movie:
            UserMoviesContainer.watchlistIDs.append(item.idValue)
        case .tv:
            UserMoviesContainer.watchlistIDs.append(item.idValue)
        case .none:
            break
        }
    }
    
    private func removeWatchlistStorage(item: MediaItemModel) {
        switch self.itemModel.mediaType {
        case .movie:
            UserMoviesContainer.watchlistIDs = UserMoviesContainer.watchlistIDs.filter { $0 != item.idValue }
        case .tv:
            UserShowsContainer.watchlistIDs = UserShowsContainer.watchlistIDs.filter { $0 != item.idValue }
        case .none:
            break
        }
    }
    
    // lists  network requests
    
    private func getLists() {
        self.getFavoriteMovies()
        self.getFavoriteShows()
        self.getMoviesWatchlist()
        self.getShowsWatchlist()
    }
    
    private func getFavoriteMovies() {
        self.networking.getFavoriteMovies { [weak self] result in
            switch result {
            case .success(let model):
                UserMoviesContainer.favoritesIDs = model.results.map { $0.id }
            case .failure(let error):
                self?.eventHandler?(.error(.networkingError(error)))
            }
        }
    }
    
    private func getFavoriteShows() {
        self.networking.getFavoriteMovies { [weak self] result in
            switch result {
            case .success(let model):
                UserShowsContainer.favoritesIDs = model.results.map { $0.id }
            case .failure(let error):
                self?.eventHandler?(.error(.networkingError(error)))
            }
        }
    }
    
    private func getMoviesWatchlist() {
        self.networking.getWathchListMovies { [weak self] result in
            switch result {
            case .success(let model):
                UserMoviesContainer.watchlistIDs = model.results.map { $0.id }
            case .failure(let error):
                self?.eventHandler?(.error(.networkingError(error)))
            }
        }
    }
    
    private func getShowsWatchlist() {
        self.networking.getWatchListShows { [weak self] result in
            switch result {
            case .success(let model):
                UserShowsContainer.watchlistIDs = model.results.map { $0.id }
            case .failure(let error):
                self?.eventHandler?(.error(.networkingError(error)))
            }
        }
    }
    
    // MARK: - Event Methods
    
    func onBack() {
        self.eventHandler?(.back)
    }
    
    func onSimilarsItem(with model: DiscoverCellModel) {
        self.eventHandler?(.onMediaItem(model))
    }
    
    func onPlay(item: MediaItemModel) {
        self.eventHandler?(.onPlay(item))
    }
    
    func onActor(actor: ActorModel) {
        self.eventHandler?(.onActor(actor))
    }
    
}
