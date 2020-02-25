//
//  MediaItemPresenter.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 25.02.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

enum MediaItemEvent: EventProtocol {
    case someCase
}

protocol MediaItemPresenter: Presenter {
    var showActivity: ((ActivityState) -> Void)? { get set }
}

class MediaItemPresenterImpl: MediaItemPresenter {
   
     // MARK: - Private Properties
    
    internal let eventHandler: ((MediaItemEvent) -> Void)?
    internal var showActivity: ((ActivityState) -> Void)?
    private let networking: NetworkManager
    var view = MediaItemView()
    
    // MARK: - Init and deinit
      
     init(networking: NetworkManager, event: ((MediaItemEvent) -> Void)?) {
             self.networking = networking
             self.eventHandler = event
         }
    
     // MARK: - Methods
    
    func getMediaItem() {
        
    }
}
