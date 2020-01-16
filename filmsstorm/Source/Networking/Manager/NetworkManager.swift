//
//  NetworkManager.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 08.01.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

class NetworkManager {
    // MARK: - Properties

    private let router = Router<APIEndPoint>(networkService: NetworkService())
    
   // MARK: - Networking methods

    func getToken(completion: @escaping (Result<RequestToken, NetworkError>) -> Void) {
        self.router.request(.auth(.createRequestToken), completion: completion)
    }
    
    func validateToken(with model: AuthRequestModel, completion: @escaping (Result<RequestToken, NetworkError>) -> Void) {
        self.router.request(.auth(.validateRequestToken(model)), completion: completion)
    }

    
    
    
    
    
    
    
    
//    func getToken(completion: @escaping (Result<String, Error>) -> Void) {
//        router.request(.auth(.createRequestToken)) { (data, response, error) in
//            if let error = error {
//                completion(.failure(error))
//            }
//            if let response = response as? HTTPURLResponse {
//                let result = self.handleNetworkResponse(response)
//                switch result {
//                case .success:
//                    guard let responseData = data else {
//                        error.map { completion(.failure($0)) }
//                        return
//                    }
//                    do {
//                        let apiResponse = try JSONDecoder().decode(RequestToken.self, from: responseData)
//                        completion(.success(apiResponse.requestToken))
//                    } catch {
//                        completion(.failure(error))
//                    }
//
//                case .failure:
//                    completion(.failure(error!))
//
//                }
//            }
//        }
//    }
//
//    func validateToken(username: String,
//                       password: String,
//                       requestToken: String,
//                       completion: @escaping (Result<String, Error>) -> Void) {
//        router.request(.auth(.validateRequestToken(username: username,
//                                                   password: password,
//                                                   requestToken: requestToken))) { (data, response, error) in
//                                                    if let error = error {
//                                                        completion(.failure(error))
//                                                    }
//                                                    if let response = response as? HTTPURLResponse {
//                                                        let result = self.handleNetworkResponse(response)
//                                                        switch result {
//                                                        case .success:
//                                                            guard let responseData = data else {
//                                                                error.map { completion(.failure($0)) }
//                                                                return
//                                                            }
//                                                            do {
//                                                                let apiResponse = try JSONDecoder().decode(RequestToken.self,
//                                                                                                           from: responseData)
//                                                                completion(.success(apiResponse.requestToken))
//                                                            } catch {
//                                                                completion(.failure(error))
//                                                            }
//                                                        case .failure:
//                                                            completion(.failure(error!))
//                                                        }
//                                                    }
//        }
//    }
//
//    func createSession(validToken: String, completion: @escaping (Result<String, Error>) -> Void) {
//        router.request(.auth(.createSession(validToken: validToken))) { (data, response, error) in
//            if let error = error {
//                completion(.failure(error))
//            }
//            if let response = response as? HTTPURLResponse {
//                let result = self.handleNetworkResponse(response)
//                switch result {
//                case .success:
//                    guard let responseData = data else {
//                        error.map { completion(.failure($0)) }
//                        return
//                    }
//                    do {
//                        let apiResponse = try JSONDecoder().decode(SessionID.self, from: responseData)
//                        completion(.success(apiResponse.sessionID))
//                    } catch {
//                        completion(.failure(error))
//                    }
//                case .failure:
//                    completion(.failure(error!))
//                }
//            }
//        }
//    }
//
//    func getAccountDetails(sessionID: String, completion: @escaping (Result<String, Error>) -> Void) {
//        router.request(.account(.getAccountDetails(sessionID: sessionID))) { (data, response, error) in
//            if let error = error {
//                completion(.failure(error))
//            }
//            if let response = response as? HTTPURLResponse {
//                let result = self.handleNetworkResponse(response)
//                switch result {
//                case .success:
//                    guard let responseData = data else {
//                        completion(.failure(error!))
//                        return
//                    }
//                    do {
//                        let apiResponse = try JSONDecoder().decode(UserModel.self, from: responseData)
//                        UserDefaultsContainer.username = apiResponse.username ?? ""
//                        completion(.success(apiResponse.username!))
//                    } catch {
//                        completion(.failure(error))
//                    }
//                case .failure:
//                    if let error = error {
//                        completion(.failure(error))
//                    }
//                }
//            }
//        }
//    }
//
//    func logout(sessionID: String, completion: @escaping (Result<String, Error>) -> Void) {
//        router.request(.auth(.logout(sessionID: sessionID))) { (data, response, error) in
//            if let error = error {
//                print(error)
//                completion(.failure(error))
//            }
//            if let response = response as? HTTPURLResponse {
//                let result = self.handleNetworkResponse(response)
//                switch result {
//                case .success:
//                    guard let responseData = data else {
//                        error.map { completion(.failure($0)) }
//                        return
//                    }
//                    do {
//                        let apiResponse = try JSONDecoder().decode(LogoutModel.self, from: responseData)
//                        completion(.success(String(apiResponse.success)))
//                    } catch {
//                        completion(.failure(error))
//                    }
//                case .failure:
//                    completion(.failure(error!))
//                }
//            }
//        }
//    }
//
//

}
