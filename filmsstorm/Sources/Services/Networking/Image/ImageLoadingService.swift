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
                   completion: @escaping (Result<UIImage, ImageError>) -> Void)
}

enum Path: String {
    case mainPath = "https://image.tmdb.org/t/p/w500"
    case gravatar = "https://www.gravatar.com/avatar/"
}

struct ImageLoadingServiceImpl: ImageLoadingService {
    
    // MARK: - Private properties
    
    private let cache: NSCache<NSURL, UIImage>
    private let networkService: NetworkServiceProtocol
    private let queue: DispatchQueue
    
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
                   completion: @escaping (Result<UIImage, ImageError>) -> Void) {
        let imagePath = urlString ?? ""
        guard let url = URL(string: mainPath.rawValue + imagePath) else { fatalError("Unable create url") }
        
        if let cachedImage = self.cache.object(forKey: url as NSURL) {
            completion(.success(cachedImage))
        } else {
            self.networkService.perform(request: URLRequest(url: url)) { result in
                self.queue.async {
                    switch result {
                    case .success(let data, _):
                        switch self.createImage(from: data) {
                        case .success(let image):
                            self.cache.setObject(image, forKey: url as NSURL)
                            completion(.success(image))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    case .failure:
                        completion(.failure(.unableToCreateImage))
                    }
                }
            }
        }
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
