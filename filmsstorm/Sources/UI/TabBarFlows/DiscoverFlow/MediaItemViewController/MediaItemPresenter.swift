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
    case error(AppError)
}

protocol MediaItemPresenter: Presenter {
    var showActivity: Handler<ActivityState>? { get set }
    var itemModel: DiscoverCellModel { get }
    
    func onBack()
    func onSimilarsItem(with model: DiscoverCellModel)
    
    func addToWatchList(_ item: MediaItemModel?)
    func addToFavourites(_ item: MediaItemModel?)
    func getItemDetails(_ completion: ((MediaItemModel) -> Void)?)
    func getItemVideo(_ item: DiscoverCellModel?)
    func getItemSimilars(_ completion: (([DiscoverCellModel]) -> Void)?)
    func getItemCast(_ completion: (([ActorModel]) -> Void)?)
}

class MediaItemPresenterImpl: MediaItemPresenter {
    
    // MARK: - Private Properties
    
    let eventHandler: Handler<MediaItemEvent>?
    var showActivity: Handler<ActivityState>?
    private let networking: NetworkManager
    let itemModel: DiscoverCellModel
    
    // MARK: - Init and deinit
    
    init(networking: NetworkManager, event: Handler<MediaItemEvent>?, itemModel: DiscoverCellModel) {
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
    
    //item videos
    
    func getItemVideo(_ item: DiscoverCellModel?) {
        guard let item = item else { return }
        
        switch item.mediaType {
            
        case .movie:
            self.networking.getMovieVideos(with: item) { [weak self] result in
                switch result {
                case .success(let videoModel):
                    print("video movie result:", videoModel.results[0].name)
                case .failure(let error):
                    print("video movie result:", error.stringDescription)
                    self?.eventHandler?(.error(.networkingError(error)))
                }
            }
            
        case .tv:
            self.networking.getShowVideos(with: item) { result in
                switch result {
                case .success(let videoModel):
                    print("show movie result:", videoModel.results[0].name)
                case .failure(let error):
                    print("show movie result:", error.stringDescription)
                    self.eventHandler?(.error(.networkingError(error)))
                }
            }
        }
    }
    
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
                print(error.stringDescription)
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
                print(error.stringDescription)
                self.eventHandler?(.error(.networkingError(error)))
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
}
