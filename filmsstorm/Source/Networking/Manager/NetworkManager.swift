//
//  NetworkManager.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 08.01.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

struct NetworkManager {
    // MARK: - Static properties
    
    static let apiKey = "f4559f172e8c6602b3e2dd52152aca52"
    private let router = Router<MovieApi>()
    
    // MARK: - Network responses list
    
    enum NetworkResponse: String {
        case sucсess
        case authenticationError = "You need to be autenticated first."
        case badRequest = "Bad request."
        case outdated = "The url you request is outdated."
        case failed = "Network requestt failed."
        case noData = "Response returned with no data to decode."
        case unableToDecode = "We could not decode the response."
    }
    
    // MARK: - Results
    
    enum Result1<String> {
        case success
        case failure(String)
    }
    
    // MARK: - Response handler
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result1<String> {
        switch response.statusCode {
        case 200...299:
            return .success
        case 401...500:
            return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599:
            return .failure(NetworkResponse.badRequest.rawValue)
        case 600:
            return .failure(NetworkResponse.outdated.rawValue)
        default:
            return .failure(NetworkResponse.failed.rawValue)
        }
    }
    
    // MARK: - Networking methods
    
    func getToken(completion: @escaping (Result<String, Error>) -> Void) {
        print("get token NM")
        router.request(.createRequestToken) { (data, response, error) in
            print("errorNM", error.debugDescription)
            guard let error = error else {
                return
            }
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(.failure(error))
                        return
                    }
                    do {
                        let apiResponse = try JSONDecoder().decode(RequestToken.self, from: responseData)
                        completion(.success(apiResponse.requestToken))
                        print("NM", apiResponse.requestToken)
                    } catch {
                        completion(.failure(error))
                    }
                    
                case .failure(_):
                    completion(.failure(error))
                    
                }
            }
        }
    }
    
    func validateToken(username: String,
                       password: String,
                       requestToken: String,
                       completion: @escaping (Result<String, Error>) -> Void) {
        router.request(.validateRequestToken(username: username,
                                             password: password,
                                             requestToken: requestToken)) { (data, response, error) in
                                                guard let error = error else { return }
                                                if let response = response as? HTTPURLResponse {
                                                    let result = self.handleNetworkResponse(response)
                                                    switch result {
                                                    case .success:
                                                        guard let responseData = data else {
                                                            completion(.failure(error))
                                                            return
                                                        }
                                                        do {
                                                            let apiResponse = try JSONDecoder().decode(RequestToken.self,
                                                                                                       from: responseData)
                                                            completion(.success(apiResponse.requestToken))
                                                        } catch {
                                                            completion(.failure(error))
                                                        }
                                                    case .failure(_):
                                                        completion(.failure(error))
                                                    }
                                                }
        }
    }
    
    
    func createSession(validToken: String, completion: @escaping (Result<String, Error>) -> Void) {
        router.request(.createSession(validToken: validToken)) { (data, response, error) in
            guard let error = error else { return }
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(.failure(error))
                        return
                    }
                    do {
                        let apiResponse = try JSONDecoder().decode(SessionID.self, from: responseData)
                        completion(.success(apiResponse.sessionID))
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(_):
                    completion(.failure(error))
                }
                
                
            }
        }
    }
    
//    func validaeToken(username: String,
//                       password: String,
//                       requsetToken: String,
//                       completion: @escaping(_ requestToken: String?, _ error: String?) -> Void) {
//        router.request(.validateRequestToken(username: username, password: password, requsetToken: requsetToken)) { (data, response, error) in
//            if error != nil {
//                completion(nil, "Please check your network connection.")
//            }
//
//            if let response = response as? HTTPURLResponse {
//                let result = self.handleNetworkResponse(response)
//                switch result {
//                case .sucsess:
//                    guard let responseData = data else {
//                        completion(nil, NetworkResponse.noData.rawValue)
//                        return
//                    }
//                    do {
//                        let apiResponse = try JSONDecoder().decode(RequestToken.self, from: responseData)
//                        completion(apiResponse.requestToken, nil)
//                    } catch {
//                        completion(nil, NetworkResponse.unableToDecode.rawValue)
//                    }
//                case .failure(let networkFailureError):
//                    completion(nil, networkFailureError)
//                }
//            }
//        }
//    }
    
//    func creatSession(validToken: String,
//                       completion: @escaping(_ sessionId: String?, _ error: String?) -> Void) {
//        router.request(.createSession(validToken: validToken)) { (data, response, error) in
//            print("sess get")
//            if error != nil {
//                print(error.debugDescription)
//                completion(nil, "Please check your network connection.")
//            }
//            if let response = response as? HTTPURLResponse {
//                let result = self.handleNetworkResponse(response)
//                switch result {
//                case .sucsess:
//                    guard let responseData = data else {
//                        completion(nil, NetworkResponse.noData.rawValue)
//                        return
//                    }
//                    do {
//                        let apiResponse = try JSONDecoder().decode(SessionID.self, from: responseData)
//                        completion(apiResponse.sessionID, nil)
//                        print("NM sessID", apiResponse.sessionID)
//                    } catch {
//                        completion(nil, NetworkResponse.unableToDecode.rawValue)
//                    }
//                case .failure(let networkFailureError):
//                    completion(nil, networkFailureError)
//                }
//            }
//        }
//    }
    
//    func getUserDetails(completion: @escaping(_ usermodel: UserModel?, _ error: String?) -> Void) {
//        router.request(.getAccountDetails) { (data, response, error) in
//            if error != nil {
//                completion(nil, "Please check your network connection.")
//            }
//            if let response = response as? HTTPURLResponse {
//                let result = self.handleNetworkResponse(response)
//                switch result {
//                case .sucsess:
//                    guard let responseData = data else {
//                        completion(nil, NetworkResponse.noData.rawValue)
//                        return
//                    }
//                    do {
//                        let apiresponse = try JSONDecoder().decode(UserModel.self, from: responseData)
//                        completion(apiresponse, nil)
//                    } catch {
//                        completion(nil, NetworkResponse.unableToDecode.rawValue)
//                    }
//                case .failure(let networkFailureError):
//                    completion(nil, networkFailureError)
//                }
//            }
//        }
//    }
    
//    func logout(sessionId: String, completion: @escaping(_ logoutModel: LogoutModel?, _ error: String?) -> Void) {
//        router.request(.logout(sessionID: sessionId)) { (data, response, error) in
//            if error != nil {
//                completion(nil, "Please check your network connection.")
//            }
//            if let response = response as? HTTPURLResponse {
//                print(response.statusCode)
//                let result = self.handleNetworkResponse(response)
//                switch result {
//                case .sucsess:
//                    guard let responseData = data else {
//                        completion(nil, NetworkResponse.noData.rawValue)
//                        return
//                    }
//                    print(responseData)
//                case .failure(let networkFailureError):
//                    completion(nil, networkFailureError)
//                    print(networkFailureError)
//                }
//            }
//        }
//    }
}

