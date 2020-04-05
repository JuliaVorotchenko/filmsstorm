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
    case error(AppError)
}

protocol MediaItemPresenter: Presenter {
    var showActivity: Handler<ActivityState>? { get set }
    var itemModel: ConfigureModel { get }
    var favoriteIDs: [Int] { get set }
    var watchlistIDs: [Int] { get set }
    var inFavorites: Bool { get }
    var inWatchlist: Bool { get set }
    
    func onBack()
    func onSimilarsItem(with model: DiscoverCellModel)
    func onPlay(item: MediaItemModel)
    
    func addToWatchList(_ item: MediaItemModel?)
    func addToFavourites(_ item: MediaItemModel?)
    func getItemDetails(_ completion: ((MediaItemModel) -> Void)?)
    func getItemSimilars(_ completion: (([DiscoverCellModel]) -> Void)?)
    func getItemCast(_ completion: (([ActorModel]) -> Void)?)
    func getFav(_ completion: ((MediaItemModel) -> Void)?)
    func getWatchlists()
    
}

class MediaItemPresenterImpl: MediaItemPresenter {

    
    // MARK: - Private Properties
    
    let eventHandler: Handler<MediaItemEvent>?
    var showActivity: Handler<ActivityState>?
    private let networking: NetworkManager
    let itemModel: ConfigureModel
    
    var favoriteIDs = [Int]()
    var watchlistIDs = [Int]()
    var inFavorites: Bool = false
    var inWatchlist: Bool = false
    
    // MARK: - Init and deinit
    
    init(networking: NetworkManager, event: Handler<MediaItemEvent>?, itemModel: ConfigureModel) {
        self.networking = networking
        self.eventHandler = event
        self.itemModel = itemModel
    }
    
    // MARK: - Networking Methods
    
    //item details
    
    func getItemDetails(_ completion: ((MediaItemModel) -> Void)?) {
        switch self.itemModel.mediaType {
        case .movie:
            self.networking.getMovieDetails(with: self.itemModel) { [weak self] result in
                switch result {
                case .success(let detailsModel):
                    completion?(MediaItemModel.create(detailsModel))
                case .failure(let error):
                    self?.eventHandler?(.error(.networkingError(error)))
                }
            }
            
        case .tv:
            self.networking.getShowDetails(with: self.itemModel) { [weak self] result in
                switch result {
                case .success(let detailsModel):
                    completion?(MediaItemModel.create(detailsModel))
                case .failure(let error):
                    self?.eventHandler?(.error(.networkingError(error)))
                }
            }
        }
    }
    
    //item cast
    
    func getItemCast(_ completion: (([ActorModel]) -> Void)?) {
        switch self.itemModel.mediaType {
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
        switch self.itemModel.mediaType {
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
                    completion?(results.map(DiscoverCellModel.create))
                case .failure(let error):
                    self.eventHandler?(.error(.networkingError(error)))
                }
            }
        }
    }
    
    //add to lists
    
    func addToFavourites(_ item: MediaItemModel?) {
        guard let item = item else { return }
        let model = AddFavouritesRequestModel(mediaType: item.mediaType.rawValue,
                                              mediaID: item.id,
                                              isFavourite: true)
        self.networking.addToFavourites(with: model) { result in
            switch result {
            case .success(let response):
                print("liked", response.statusMessage)
            case .failure(let error):
                self.eventHandler?(.error(.networkingError(error)))
            }
        }
    }
    
    func addToWatchList(_ item: MediaItemModel?) {
        guard let item = item else { return }
        let model = AddWatchListRequestModel(mediaType: item.mediaType.rawValue,
                                             mediaID: item.id,
                                             toWatchList: true)
        self.networking.addToWatchlist(with: model) { result in
            switch result {
            case .success(let response):
                print("added watchlist", response.statusMessage)
            case .failure(let error):
                self.eventHandler?(.error(.networkingError(error)))
            }
        }
    }
    
    //lists requests
   
    func getFav(_ completion: ((MediaItemModel) -> Void)?) {
        switch self.itemModel.mediaType {
        case .movie:
            self.networking.getFavoriteMovies { [weak self] result in
                switch result {
                case .success(let favMovies):
                    let temp = favMovies.results
                        .filter { $0.id == self?.itemModel.id }
                        .first
                    let result = temp.map {MediaItemModel.create($0)}
            
                   
                    completion?(ids.contains(id))
                case .failure(let error):
                    self?.eventHandler?(.error(.networkingError(error)))
                }
            }
        case .tv:
            self.networking.getFavoriteShows { [weak self] result in
                switch result {
                case .success(let favShows):
                    let ids = favShows.results.map { $0.id }
                    guard let id = self?.itemModel.id else { return }
                    completion?(ids.contains(id))
                case .failure(let error):
                    self?.eventHandler?(.error(.networkingError(error)))
                }
            }
        }
    }
//
//    internal func getFavorites() {
//        switch self.itemModel.mediaType {
//        case .movie:
//            self.networking.getFavoriteMovies { [weak self] result in
//                switch result {
//                case .success(let favMovies):
//                    self?.favoriteIDs = favMovies.results.map { $0.id }
//                case .failure(let error):
//                    self?.eventHandler?(.error(.networkingError(error)))
//                }
//            }
//        case .tv:
//            self.networking.getFavoriteShows { [weak self] result in
//                switch result {
//                case .success(let favShows):
//                    self?.favoriteIDs = favShows.results.map { $0.id }
//                case .failure(let error):
//                    self?.eventHandler?(.error(.networkingError(error)))
//                }
//            }
//        }
//    }
    
    internal func getWatchlists() {
        switch self.itemModel.mediaType {
        case .movie:
            self.networking.getWathchListMovies { [weak self] result in
                switch result {
                case .success(let watchlistMov):
                     self?.watchlistIDs = watchlistMov.results.map { $0.id }
                case .failure(let error):
                    print(#function, error.localizedDescription)
                    self?.eventHandler?(.error(.networkingError(error)))
                }
            }
        case .tv:
            self.networking.getWatchListShows { [weak self] result in
                switch result {
                case .success(let watchlistShows):
                    self?.watchlistIDs = watchlistShows.results.map { $0.id }
                case .failure(let error):
                    print(#function, error.localizedDescription)
                    self?.eventHandler?(.error(.networkingError(error)))
                }
            }
        }
    }
    
//    func getLists() {
//         print(#function, self.inFavorites)
//        self.getFavorites()
//        self.getWatchlists()
//    }
    
//    func isInFavorites() {
//        self.getLists()
//        if self.favoriteIDs.contains(self.itemModel.id) {
//            self.inFavorites = true
//        }
//        print(#function, self.inFavorites)
//    }
    
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
    
}
