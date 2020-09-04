//
//  ShowsPresenter.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 24.02.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

enum ShowsEvent: EventProtocol {
    case mediaItem(ConfigureModel)
    case back
    case error(AppError)
}

class ShowPresenterImpl: ItemsPresenter {
    
    // MARK: - Private Properties
    
    let eventHandler: Handler<ShowsEvent>
    var showActivity: Handler<ActivityState>?
    private let networking: ItemsNeworkManager
    let title = Constants.showsTitle
    
    // MARK: - Init and deinit
    
    init(networking: ItemsNeworkManager, event: @escaping (ShowsEvent) -> Void) {
        self.networking = networking
        self.eventHandler = event
    }
    
    // MARK: - Methods
    
    func getItems(_ completion: Handler<[DiscoverCellModel]>?) {
        self.networking.getPopularShows { [weak self] result in
            switch result {
            case .success(let model):
                completion?(model.results.map(DiscoverCellModel.create))
                
            case .failure(let error):
                self?.eventHandler(.error(.networkingError(error)))
            }
        }
    }
    
    func onMedia(item: DiscoverCellModel) {
        self.eventHandler(.mediaItem(item))
    }
    
    func onBack() {
        self.eventHandler(.back)
    }
}
