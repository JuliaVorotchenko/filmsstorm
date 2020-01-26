//
//  ImageLoadingService.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 26.01.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

protocol ImageLoadingService {
    @discardableResult func loadImage(from urlString: String?, completion: @escaping (Result<UIImage, ImageError>) -> Void) -> URLSessionDataTask
}

struct ImageLoadingServiceImpl: ImageLoadingService {
    private let networkService: NetworkServiceProtocol
    private let queue: DispatchQueue
    
    init(networkService: NetworkServiceProtocol = NetworkService(), queue: DispatchQueue = .main) {
        self.networkService = networkService
        self.queue = queue
    }
    
    func loadImage(from urlString: String?, completion: @escaping (Result<UIImage, ImageError>) -> Void) -> URLSessionDataTask {
        let path = "https://image.tmdb.org/t/p/w500"
        let imagePath = urlString ?? ""
        guard let url = URL(string: path + imagePath) else { fatalError("Unable create url") }
        return self.networkService.perform(request: URLRequest(url: url)) { result in
            self.queue.async {
                switch result {
                case .success(let data, _):
                    completion(self.createImage(from: data))
                case .failure:
                    completion(.failure(.unableToCreateImage))
                }
            }
        }
    }
    
    private func createImage(from data: Data?) -> Result<UIImage, ImageError> {
        guard let data = data else { return .failure(.unableToCreateImage) }
        return UIImage(data: data).flatMap { .success($0) } ?? .failure(.unableToCreateImage)
    }
}

enum ImageError: Error {
    case unableToCreateImage
}
