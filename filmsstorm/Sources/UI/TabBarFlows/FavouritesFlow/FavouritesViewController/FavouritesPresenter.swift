//
//  FavouritesPresenter.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 25.02.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

enum FavouritesEvent: EventProtocol {
    case unowned
}

protocol FavouritesPresenter: Presenter {
    var showActivity: ((ActivityState) -> Void)? { get set }
}

class FavouritesPresenterImpl: FavouritesPresenter {
    
    // MARK: - Private Properties
    
    internal let eventHandler: ((FavouritesEvent) -> Void)?
    internal var showActivity: ((ActivityState) -> Void)?
    private let networking: NetworkManager
    
    // MARK: - Init and deinit
    
    init(networking: NetworkManager, event: ((FavouritesEvent) -> Void)?) {
        self.networking = networking
        self.eventHandler = event
    }
}
