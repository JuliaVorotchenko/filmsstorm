//
//  File.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 02.04.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

enum VideoEvent: EventProtocol {
    case back
    case error(AppError)
}

protocol VideoPlayerViewPresenter: Presenter {
    var showActivity: Handler<ActivityState>? { get set }
    var item: MediaItemModel { get }
    func onBack()
}

class VideoPlayerViewPresenterImpl: VideoPlayerViewPresenter {
   
    // MARK: - Private Properties
    
    let eventHandler: Handler<VideoEvent>?
    var showActivity: Handler<ActivityState>?
    let item: MediaItemModel
    private let networking: NetworkManager
    
    // MARK: - Init and deinit
    
    init(networking: NetworkManager, event: ((VideoEvent) -> Void)?, item: MediaItemModel) {
          self.networking = networking
          self.eventHandler = event
        self.item = item
      }
    
    // MARK: - Methods
    
    func onBack() {
        self.eventHandler?(.back)
    }
}
