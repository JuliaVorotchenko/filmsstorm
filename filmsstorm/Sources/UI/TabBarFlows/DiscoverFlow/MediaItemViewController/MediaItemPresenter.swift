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
    case error(AppError)
}

protocol MediaItemPresenter: Presenter {
    var showActivity: Handler<ActivityState>? { get set }
    var itemModel: DiscoverCellModel { get }

    func onBack()

    func getMovieSimilars(_ completion: (([DiscoverCellModel]) -> Void)?)
    func getShowSimilars(_ completion: (([ShowListResult]) -> Void)?)

    func getItemDetails(_ completion: ((MediaItemModel) -> Void)?)
    func getItemVideo(_ item: DiscoverCellModel?)

    func addToFavourites(_ item: DiscoverCellModel?)
    func addToWatchList(_ item: DiscoverCellModel?)

    func getMovieCast(_ completion: (([ActorModel]) -> Void)?)
    func getShowCast(_ completion: (([ActorModel]) -> Void)?)
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
    
    func getMovieCast(_ completion: (([ActorModel]) -> Void)?) {
        self.networking.getMovieCredits(with: self.itemModel) { [weak self] result in
            switch result {
            case .success(let creditsModel):
                creditsModel.cast.map { completion?($0.map(ActorModel.create)) }
            case .failure(let error):
                self?.eventHandler?(.error(.networkingError(error)))
            }
        }
    }

    func getShowCast(_ completion: (([ActorModel]) -> Void)?) {
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
    
    //item similars
    
    func getMovieSimilars(_ completion: (([DiscoverCellModel]) -> Void)?) {
        print(#function)
        self.networking.getMovieSimilars(with: self.itemModel) { result in
            switch result {
            case .success(let similarsModel):
                guard let results = similarsModel.results else { return }
                completion?(results.map(DiscoverCellModel.create))
            case .failure(let error):
                self.eventHandler?(.error(.networkingError(error)))
            }
        }
    }
    
    func getShowSimilars(_ completion: (([ShowListResult]) -> Void)?) {
        self.networking.getShowSimilars(with: self.itemModel) { result in
            switch result {
            case.success(let similarsModel):
                guard let results = similarsModel.results else { return }
                completion?(results)
            case .failure(let error):
                self.eventHandler?(.error(.networkingError(error)))
            }
        }
        
    }
    
    func getItemVideo(_ item: DiscoverCellModel?) {
        guard let item = item else { return }
        
        switch item.mediaType {
            
        case .movie:
            self.networking.getMovieVideos(with: item) { [weak self] result in
                switch result {
                case .success(let videoModel):
                    F.Log("video movie result: \(videoModel.results)")
                case .failure(let error):
                    self?.eventHandler?(.error(.networkingError(error)))
                }
            }
            
        case .tv:
            self.networking.getShowVideos(with: item) { result in
                switch result {
                case .success(let videoModel):
                    F.Log("show movie result: \(videoModel.results)")
                case .failure(let error):
                    self.eventHandler?(.error(.networkingError(error)))
                }
            }
        }
    }
    
    func addToFavourites(_ item: DiscoverCellModel?) {
        guard let item = item else { return }
        let model = AddFavouritesRequestModel(mediaType: item.mediaType.rawValue,
                                              mediaID: item.id,
                                              isFavourite: true)
        self.networking.addToFavourites(with: model) { result in
            switch result {
            case .success(let response):
                F.Log("added watchlist \(response.statusMessage)")
            case .failure(let error):
                self.eventHandler?(.error(.networkingError(error)))
            }
        }
    }
    
    func addToWatchList(_ item: DiscoverCellModel?) {
        guard let item = item else { return }
        let model = AddWatchListRequestModel(mediaType: item.mediaType.rawValue,
                                             mediaID: item.id,
                                             toWatchList: true)
        self.networking.addToWatchlist(with: model) { result in
            switch result {
            case .success(let response):
                F.Log("added watchlist \(response.statusMessage)")
            case .failure(let error):
                self.eventHandler?(.error(.networkingError(error)))
            }
        }
    }
    
    // MARK: - Event Methods
    
    func onBack() {
        self.eventHandler?(.back)
    }
}
