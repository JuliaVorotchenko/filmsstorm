//
//  NetworkService.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 17.01.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

protocol NetworkServiceProtocol {
    @discardableResult func perform(request: URLRequest,
                                    completion: @escaping (Result<(Data?, HTTPURLResponse), NetworkError>) -> Void)
        -> URLSessionDataTask
}

class NetworkService: NetworkServiceProtocol {
    private let session: URLSession
    
    init() {
        let configuration = URLSessionConfiguration.default
        self.session = URLSession(configuration: configuration)
    }
    
    @discardableResult func perform(request: URLRequest,
                                    completion: @escaping (Result<(Data?, HTTPURLResponse), NetworkError>) -> Void)
        -> URLSessionDataTask {
           // F.Log(request.debugDescription)
            let dataTask = self.session.dataTask(with: request) { data, response, error in
                guard let response = response as? HTTPURLResponse else {
                    completion(.failure(.other(URLError: error)))
                    return
                }
                
                completion(.success((data, response)))
            }
            dataTask.resume()
            
            return dataTask
    }
}
