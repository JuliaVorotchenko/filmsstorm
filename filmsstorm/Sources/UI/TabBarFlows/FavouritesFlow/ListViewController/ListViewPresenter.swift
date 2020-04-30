//
//  ListViewPresenter.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 30.04.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

enum ListEvent: EventProtocol {
    case onMedia(DiscoverCellModel)
    case back
    case error(AppError)
}

protocol ListViewPresenter: Presenter {
    func onMedia(item: DiscoverCellModel)
    func back()
}

class ListViewPresenterImpl: ListViewPresenter {
    
    // MARK: - Private Properties
    
    let eventHandler: Handler<ListEvent>?
    private let networking: NetworkManager
    
    // MARK: - Init and deinit
    
    init(networking: NetworkManager, event: Handler<ListEvent>?) {
        self.networking = networking
        self.eventHandler = event
    }
    
    // MARK: - Network Requests
    
    // MARK: - Action Methods
    
    func onMedia(item: DiscoverCellModel) {
        self.eventHandler?(.onMedia(item))
    }
    
    func back() {
        self.eventHandler?(.back)
    }
}
