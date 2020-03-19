//
//  DiscoverPresentationService.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 23.02.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

enum DiscoverEvent: EventProtocol {
    case error(AppError)
    case onHeaderEvent(DiscoverHeaderEvent)
    case onMediaItem(DiscoverCellModel, MediaItemModel)
    
}

protocol DiscoverPresenter: Presenter {
    var  showActivity: Handler<ActivityState>? { get set }
    var mediaIemModel: MediaItemModel? { get set }
    func getPopularMovies(_ completion: (( [MovieListResult]) -> Void)?)
    func onMovies()
    func onShows()
    func onSearch()
    func onMedia(item: DiscoverCellModel, itemDetails: MediaItemModel)
    func addToFavourites(_ item: DiscoverCellModel?)
    func addToWatchList(_ item: DiscoverCellModel?)
    func getItemDetails(_ item: DiscoverCellModel)
}

class DiscoverPresenterImpl: DiscoverPresenter {
    
    // MARK: - Private Properties
    let eventHandler: Handler<DiscoverEvent>?
    var showActivity: Handler<ActivityState>?
    var mediaIemModel: MediaItemModel? = .none
    private let networking: NetworkManager
    
    // MARK: - Init and deinit
    
    init(networking: NetworkManager, event: Handler<DiscoverEvent>?) {
        self.networking = networking
        self.eventHandler = event
    }
    
    // MARK: - Networking Methods
    
    func getPopularMovies(_ completion: (( [MovieListResult]) -> Void)?) {
        self.networking.getUpcomingMovies { [weak self] result in
            switch result {
            case .success(let model):
                completion?(model.results)
            case .failure(let error):
                self?.eventHandler?(.error(.networkingError(error)))
            }
        }
    }
    
    func addToFavourites(_ item: DiscoverCellModel?) {
        guard let item = item else { return }
        let model = AddFavouritesRequestModel(mediaType: item.mediaType.rawValue, mediaID: item.id, isFavourite: true)
        self.networking.addToFavourites(with: model) { result in
            switch result {
            case .success(let response):
                print(response.statusMessage)
            case .failure(let error):
                print(error.stringDescription)
                
            }
        }
    }
    
    func addToWatchList(_ item: DiscoverCellModel?) {
        
        guard let item = item else { return }
        let model = AddWatchListRequestModel(mediaType: item.mediaType.rawValue, mediaID: item.id, toWatchList: true)
        self.networking.addToWatchlist(with: model) { result in
            switch result {
            case .success(let response):
                print(response.statusMessage)
            case .failure(let error):
                print(error.stringDescription)
            }
        }
    }
    
    func getItemDetails(_ item: DiscoverCellModel) {
        print(#function)
        switch item.mediaType {
            
        case .movie:
            
            self.networking.getMovieDetails(with: item) { result in
                
                switch result {
                case .success(let detailsModel):
                    self.mediaIemModel = MediaItemModel.create(detailsModel)
                    print("itemDet pres:", self.mediaIemModel)
                    print("movie details model:", detailsModel.originalTitle as Any)
                case .failure(let error):
                    print("moviedetails error", error.stringDescription)
                }
            }
            
        case .tv:
            self.networking.getShowDetails(with: item) { result in
                switch result {
                case .success(let detailsModel):
                    self.mediaIemModel = MediaItemModel.create(detailsModel)
                    print("itemDet pres:", self.mediaIemModel)
                    print("show details model:", detailsModel.name as Any)
                case .failure(let error):
                    print("show error", error.stringDescription)
                }
            }
        }
        
        
    }
    
    // MARK: - Activity Movies
    
    func onMovies() {
        self.eventHandler?(.onHeaderEvent(.onMovies))
    }
    
    func onShows() {
        self.eventHandler?(.onHeaderEvent(.onShows))
    }
    
    func onSearch() {
        self.eventHandler?(.onHeaderEvent(.onSearch))
    }
    
    func onMedia(item: DiscoverCellModel, itemDetails: MediaItemModel) {
         self.eventHandler?(.onMediaItem(item, itemDetails))
    }
}
