//
//  ImageLoadingService.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 26.01.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

protocol ImageLoadingService {
    
    func loadImage(from urlString: String?,
                   mainPath: Path,
                   completion: ((Result<UIImage, ImageError>) -> Void)?)
    func cancelLoading()
}

enum Path: String {
    
    static var mainPath: String {
        if ImageQualitySettingContainer.imageQualityIsHigh {
            return self.highQualityPath.rawValue
        } else {
            return self.middleQualityPath.rawValue
        }
    }

    case highQualityPath = "https://image.tmdb.org/t/p/w500"
    case middleQualityPath = "https://image.tmdb.org/t/p/w185"
    case gravatar = "https://www.gravatar.com/avatar/"
    case youtube = "https://www.youtube.com/embed/"
}

class ImageLoadingServiceImpl: ImageLoadingService {
    
    // MARK: - Private properties
    
    private let cache: NSCache<NSURL, UIImage>
    private let networkService: NetworkServiceProtocol
    private let queue: DispatchQueue
    private var dataTask: URLSessionDataTask?
    
    // MARK: - Initialization
    
    init(networkService: NetworkServiceProtocol = NetworkService(),
         queue: DispatchQueue = .main) {
        self.cache = .init()
        self.networkService = networkService
        self.queue = queue
    }
    
    // MARK: - Public methods
    
    func loadImage(from urlString: String?,
                   mainPath: Path,
                   completion: ((Result<UIImage, ImageError>) -> Void)?) {
        let imagePath = urlString ?? ""
        guard let url = URL(string: mainPath.rawValue + imagePath) else { fatalError("Unable create url") }
        
        if let cachedImage = self.cache.object(forKey: url as NSURL) {
            completion?(.success(cachedImage))
        } else {
            self.dataTask = self.networkService.perform(request: URLRequest(url: url)) { [weak self] result in
                guard let `self` = self else { return }
                self.queue.async {
                    switch result {
                    case .success(let data, _):
                        switch self.createImage(from: data) {
                        case .success(let image):
                            self.cache.setObject(image, forKey: url as NSURL)
                            completion?(.success(image))
                        case .failure(let error):
                            completion?(.failure(error))
                        }
                    case .failure:
                        completion?(.failure(.unableToCreateImage))
                    }
                }
            }
            self.dataTask?.resume()
        }
    }
    
    func cancelLoading() {
        self.dataTask?.cancel()
    }
    
    // MARK: - Private methods
    
    private func createImage(from data: Data?) -> Result<UIImage, ImageError> {
        return data
            .flatMap(UIImage.init)
            .flatMap(Result.success) ?? .failure(.unableToCreateImage)
    }
}

enum ImageError: Error {
    case unableToCreateImage
}
