//
//  Router.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 08.01.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

class Router<EndPoint: EndPointType>: NetworkRouter {
    private var task: URLSessionTask?
    private let queue: DispatchQueue
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol, queue: DispatchQueue = .main) {
        self.networkService = networkService
        self.queue = queue
        
    }
    
    func request<T: Codable>(_ route: EndPoint, completion: @escaping (Result<T, NetworkError>) -> Void) {
        do {
            let request = try self.buildRequest(from: route)
           //F.Log(request.url)
            self.networkService.perform(request: request) { [weak self] result in
                guard let `self` = self else { return }
                self.queue.async {
                    switch result {
                    case .success( let data, let response):
                        self.handleNetworkResponse(data, response: response, completion: completion)
                    case .failure( let error):
                        completion(.failure(error))
                    }
                }
            }
        } catch {
            completion(.failure(.other(URLError: error)))
        }
        self.task?.resume()
    }
    
    private func handleNetworkResponse<T: Codable>(_ data: Data?,
                                                   response: HTTPURLResponse,
                                                   completion: @escaping (Result<T, NetworkError>) -> Void) {
        switch response.statusCode {
        case 200...300:
            completion(self.decode(data))
        case 401...500:
            completion(.failure(.networkingResponse(.authenticationError)))
        case 501...599:
            completion(.failure(.networkingResponse(.badRequest)))
        case 600:
            completion(.failure(.networkingResponse(.outdated)))
        default:
            completion(.failure(.networkingResponse(.failed)))
        }
    }
    
    private func buildRequest(from route: EndPoint) throws -> URLRequest {
        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 10.0)
        request.httpMethod = route.httpMethod.rawValue
            switch route.task {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Conttent-type")
                
            case .requestParameters(let bodyParameters,
                                    let urlParameters):
                try self.configureParameters(bodyParameters: bodyParameters,
                                             urlParameters: urlParameters,
                                             request: &request)
                
            case .requestParametersAndHeaders(let bodyParameters,
                                              let urlParameters,
                                              let additionalHeaders):
                self.addAdditionalHeaders(additionalHeaders,
                                          request: &request)
                try self.configureParameters(bodyParameters: bodyParameters,
                                             urlParameters: urlParameters,
                                             request: &request)
            case .requestParam(let model, let urlParameters):
                try self.configureParametres(with: model, urlParameters: urlParameters, request: &request)
                
            case .requestParamAndHeaders(let model, let urlParameters, let additionalHeaders):
                self.addAdditionalHeaders(additionalHeaders, request: &request)
                try self.configureParametres(with: model, urlParameters: urlParameters, request: &request)
            }
            return request
    }
    
    private func configureParametres(with model: Codable? ,
                                     urlParameters: Parameters? = nil ,
                                     request: inout URLRequest) throws {
        let body = model.flatMap { try? $0.encoded() }
        request.httpBody = body
        if let urlParameters = urlParameters {
            try URLParameterEncoder.encode(urlRequest: &request, with: urlParameters)
        }
    }

    private func configureParameters(bodyParameters: Parameters? = nil,
                                     urlParameters: Parameters? = nil,
                                     request: inout URLRequest) throws {
            if let bodyParameters = bodyParameters {
                try JSONParameterEncoder.encode(urlRequest: &request, with: bodyParameters)
            }
            if let urlParameters = urlParameters {
                try URLParameterEncoder.encode(urlRequest: &request, with: urlParameters)
            }
    }
    
    private func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?,
                                      request: inout URLRequest) {
        additionalHeaders.map { $0.forEach {
            request.setValue($1, forHTTPHeaderField: $0)
            }
        }
    }
    
    private func decode<Value: Decodable>(_ data: Data?) -> Result<Value, NetworkError> {
        do {
            guard let data = data else { return .failure(.encodingFailed) }
            let value = try JSONDecoder().decode(Value.self, from: data)
            return .success(value)
        } catch {
            return .failure(.encodingFailed)
        }
    }
}

extension Encodable {
    public func encoded(encoder: JSONEncoder = .init()) throws -> Data {
        encoder.outputFormatting = .prettyPrinted
        return try encoder.encode(self)
    }
}
