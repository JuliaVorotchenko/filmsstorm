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
    func getMediaItem()
    func onBack()
}

class MediaItemPresenterImpl: MediaItemPresenter {
   
     // MARK: - Private Properties
    
    let eventHandler: Handler<MediaItemEvent>?
    var showActivity: Handler<ActivityState>?
    private let networking: NetworkManager
   
    // MARK: - Init and deinit
      
     init(networking: NetworkManager, event: Handler<MediaItemEvent>?) {
             self.networking = networking
             self.eventHandler = event
         }
    
     // MARK: - Methods
    
    func getMediaItem() {
        
    }
    
    func onBack() {
        self.eventHandler?(.back)
    }
}
