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
}

protocol MediaItemPresenter: Presenter {
    var showActivity: Handler<ActivityState>? { get set }
    var itemModel: DiscoverCellModel { get set }
    func onBack()
    func getItemVideo(_ item: DiscoverCellModel?)
    func getItemDetails(_ item: DiscoverCellModel?)
    func getItemSimilars(_ item: DiscoverCellModel?)
}

class MediaItemPresenterImpl: MediaItemPresenter {


    // MARK: - Private Properties
    
    let eventHandler: Handler<MediaItemEvent>?
    var showActivity: Handler<ActivityState>?
    private let networking: NetworkManager
    var itemModel: DiscoverCellModel
    
    // MARK: - Init and deinit
    
    init(networking: NetworkManager, event: Handler<MediaItemEvent>?, itemModel: DiscoverCellModel) {
        self.networking = networking
        self.eventHandler = event
        self.itemModel = itemModel
    }
    
    // MARK: - Methods
    
    func getItemDetails(_ item: DiscoverCellModel?) {
        print(#function)
        guard let item = item else { return }
        
        switch item.mediaType {
            
        case .movie:
            self.networking.getMovieDetails(with: item) { result in
                switch result {
                case .success(let detailsModel):
                    print("movie details model:", detailsModel.originalTitle as Any)
                case .failure(let error):
                    print("moviedetails error", error.stringDescription)
                }
            }
            
        case .tv:
            self.networking.getShowDetails(with: item) { result in
                switch result {
                case .success(let detailsModel):
                    print("show details model:", detailsModel.name as Any)
                case .failure(let error):
                    print("moviedetails error", error.stringDescription)
                }
            }
        }
    }
    
    func getItemSimilars(_ item: DiscoverCellModel?) {
         print(#function)
        guard let item = item else { return }
        
        switch item.mediaType {
            
        case .movie:
            self.networking.getMovieSimilars(with: item) { result in
                switch result {
                case .success(let similarsModel):
                    print("movie similars:", similarsModel.results?.count as Any)
                case .failure(let error):
                    print("movie similars:", error.localizedDescription)
                }
            }
            
        case .tv:
            self.networking.getShowSimilars(with: item) { result in
                switch result {
                case.success(let similarsModel):
                    print("show similars:", similarsModel.results?.count as Any)
                case .failure(let error):
                    print("show similars:", error.localizedDescription)
                }
            }
        }
    }
    
    func getItemVideo(_ item: DiscoverCellModel?) {
        print(#function)
        guard let item = item else { return }
        
        switch item.mediaType {
            
        case .movie:
            self.networking.getMovieVideos(with: item) { result in
                switch result {
                case .success(let videoModel):
                    print("video movie result:", videoModel.results[0].name)
                case .failure(let error):
                    print("video movie result:", error.stringDescription)
                }
            }
            
        case .tv:
            self.networking.getShowVideos(with: item) { result in
                switch result {
                case .success(let videoModel):
                    print("show movie result:", videoModel.results[0].name)
                case .failure(let error):
                    print("show movie result:", error.stringDescription)
                }
            }
        }
    }
    
    func onBack() {
        self.eventHandler?(.back)
    }
}
