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
    var itemModel: MediaItemModel { get }
    
    func getItemVideos(_ completion: @escaping (([VideoModel]) -> Void))
    func onBack()
}

class VideoPlayerViewPresenterImpl: VideoPlayerViewPresenter {
   
    // MARK: - Private Properties
    
    let eventHandler: Handler<VideoEvent>?
    var showActivity: Handler<ActivityState>?
    let itemModel: MediaItemModel
    private let networking: NetworkManager
    
    // MARK: - Init and deinit
    
    init(networking: NetworkManager, event: ((VideoEvent) -> Void)?, item: MediaItemModel) {
          self.networking = networking
          self.eventHandler = event
        self.itemModel = item
      }
    
    //item videos
     
     func getItemVideos(_ completion: @escaping (([VideoModel]) -> Void)) {
         switch self.itemModel.mediaType {
         case .movie:
             self.networking.getMovieVideos(with: self.itemModel) { [weak self] result in
                 switch result {
                 case.success(let model):
                     completion(model.results)
                 case .failure(let error):
                     self?.eventHandler?(.error(.networkingError(error)))
                 }
             }
         case .tv:
             self.networking.getMovieVideos(with: self.itemModel) { [weak self] result in
                 switch result {
                 case.success(let model):
                      completion(model.results)
                 case .failure(let error):
                     self?.eventHandler?(.error(.networkingError(error)))
                 }
             }
         }
     }
    
    // MARK: - Methods
    
    func onBack() {
        self.eventHandler?(.back)
    }
    
}
