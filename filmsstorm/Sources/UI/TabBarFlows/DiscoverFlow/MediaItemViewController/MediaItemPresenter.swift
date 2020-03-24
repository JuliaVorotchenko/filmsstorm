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
    var itemModel: DiscoverCellModel { get set }
    var movieDetails: MovieDetailsModel? { get set }
    var showDetails: ShowDetailsModel? { get set }
    var mediaItemDetails: MediaItemModel? { get set }
    
    func onBack()
    func getItemVideo(_ item: DiscoverCellModel?)
     func getItemSimilars(_ completion: (([DiscoverCellModel]) -> Void)?)
    func getItemDetails(_ completion: ((MediaItemModel) -> Void)?)
    func addToFavourites(_ item: DiscoverCellModel?)
    func addToWatchList(_ item: DiscoverCellModel?)
     func getItemCast(_ completion: (([ActorModel]) -> Void)?) 
}

class MediaItemPresenterImpl: MediaItemPresenter {
    
    

    
    // MARK: - Private Properties
    
    let eventHandler: Handler<MediaItemEvent>?
    var showActivity: Handler<ActivityState>?
    private let networking: NetworkManager
    var itemModel: DiscoverCellModel
    
    var movieDetails: MovieDetailsModel?
    var showDetails: ShowDetailsModel?
    var mediaItemDetails: MediaItemModel?
    
    // MARK: - Init and deinit
    
    init(networking: NetworkManager, event: Handler<MediaItemEvent>?, itemModel: DiscoverCellModel) {
        self.networking = networking
        self.eventHandler = event
        self.itemModel = itemModel
    }
    
    // MARK: - Networking Methods
    
    func getItemDetails(_ completion: ((MediaItemModel) -> Void)?) {
        switch self.itemModel.mediaType {
        case .movie:
            self.networking.getMovieDetails(with: self.itemModel) { result in
                
                switch result {
                case .success(let detailsModel):
                    completion?(MediaItemModel.create(detailsModel))
                case .failure(let error):
                    self.eventHandler?(.error(.networkingError(error)))
                }
            }
            
        case .tv:
            self.networking.getShowDetails(with: self.itemModel) { result in
                switch result {
                case .success(let detailsModel):
                    completion?(MediaItemModel.create(detailsModel))
                case .failure(let error):
                    self.eventHandler?(.error(.networkingError(error)))
                }
            }
        }
    }
    
    func getItemCast(_ completion: (([ActorModel]) -> Void)?) {
        switch self.itemModel.mediaType {
        case .movie:
            self.networking.getMovieCredits(with: self.itemModel) { result in
                
                switch result {
                case .success(let creditsModel):
                    guard let movieCast = creditsModel.cast else { return }
                    completion?(movieCast.map { ActorModel.create($0)})
                case .failure(let error):
                    self.eventHandler?(.error(.networkingError(error)))
                }
            }
            
        case .tv:
            self.networking.getShowCredits(with: self.itemModel) { result in
                
                switch result {
                case .success(let creditsModel):
                   guard let movieCast = creditsModel.cast else { return }
                   completion?(movieCast.map { ActorModel.create($0)})
                case .failure(let error):
                    self.eventHandler?(.error(.networkingError(error)))
                }
            }
        }
    }
    
    func getItemSimilars(_ completion: (([DiscoverCellModel]) -> Void)?) {
        print(#function)
        switch self.itemModel.mediaType {
            
        case .movie:
            self.networking.getMovieSimilars(with: self.itemModel) { result in
                switch result {
                case .success(let similarsModel):
                    guard let moviesResult = similarsModel.results else { return }
                    completion?(moviesResult.map { DiscoverCellModel.create($0)})
                case .failure(let error):
                     self.eventHandler?(.error(.networkingError(error)))
                }
            }
            
        case .tv:
            self.networking.getShowSimilars(with: self.itemModel) { result in
                switch result {
                case.success(let similarsModel):
                    guard let moviesResult = similarsModel.results else { return }
                    completion?(moviesResult.map { DiscoverCellModel.create($0)})
                case .failure(let error):
                    self.eventHandler?(.error(.networkingError(error)))
                }
            }
        }
    }
    
    func getItemVideo(_ item: DiscoverCellModel?) {
        print(#function)
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
    
    func addToFavourites(_ item: DiscoverCellModel?) {
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
    
    func addToWatchList(_ item: DiscoverCellModel?) {
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
}
