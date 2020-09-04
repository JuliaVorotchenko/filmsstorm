//
//  LoadingImageView.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 30.03.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class LoadingImageView: UIImageView, ActivityViewPresenter {
    private let loadingService: ImageLoadingService = ImageLoadingServiceImpl()
    let loadingView = ActivityView()
    deinit {
        self.cancelLoading()
    }
    
    func loadImage(from urlString: String?, mainPath: Path?) {
        self.showActivity()
        guard let mainPath = mainPath else { return }
        self.loadingService.loadImage(from: urlString, mainPath: mainPath) { [weak self] result in
            switch result {
            case .success(let image):
                self?.hideActivity()
                self?.image = image
                
            case .failure:
                self?.hideActivity()
                self?.image = UIImage(named: "empty")
            }
        }
    }
    
    func cancelLoading() {
        self.image = UIImage(named: "empty")
        self.hideActivity()
        self.loadingService.cancelLoading()
    }
    
}
