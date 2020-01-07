//
//  Networking.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 29.12.2019.
//  Copyright © 2019 Alexander Andriushchenko. All rights reserved.
//

import Foundation
import Alamofire

class Networking {
    
    struct  Headers {
        static let contentType = "Content-type"
        static let value = "application/json"
        static let authorization = "Authorization"
        static let bearer = "Bearer \(UserDefaultsContainer.sessionToken)"
    }
   
    // MARK: - Properties

    let encoder =  JSONParameterEncoder.default
    
    // MARK: - GET token

    func getToken() {
        let session = URLSession.shared
        let url = URL(string: "https://api.themoviedb.org/3/authentication/token/new?api_key=" + apiKey)!
        let task = session.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if error != nil || data == nil {
                    print("Client Errror")
                    return
                }
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    print("Server error")
                    return
                }
                guard let mime = response.mimeType, mime == "application/json" else {
                    print("wrong mime type")
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(RequestToken.self, from: data!)
                    self.token = response
                    print("Token:", self.token?.requestToken)
                    self.validateToken()
                } catch {
                    print("JSON error: \(error.localizedDescription)")
                }
            }
            
        }
        task.resume()
    }
    
    // MARK: - Validate Token
    
    func validateToken() {
        print("validating")
        var session = URLSession.shared
        let url = URL(string: "https://api.themoviedb.org/3/authentication/token/validate_with_login?api_key=" + apiKey)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let parameters = ["username": self.rootView?.usernameTextField.text, "password": self.rootView?.passwordTextField.text, "request_token": self.token?.requestToken]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        
        let task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if error != nil || data == nil {
                    print("client Error")
                }
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    
                    return
                }
                print(response.debugDescription)
                guard let mime = response.mimeType, mime == "application/json" else {
                    print("wrong mime type")
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(RequestToken.self, from: data!)
                    self.validToken = response
                    print("Valid Token:", self.token?.requestToken)
                    self.createSessionId()
                } catch {
                    print("JSON error: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    // MARK: - Create sessionID
    
    func createSessionId() {
        
        var session = URLSession.shared
        let url = URL(string: "https://api.themoviedb.org/3/authentication/session/new?api_key=" + apiKey)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters = ["request_token": self.validToken?.requestToken]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        
        let task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if error != nil || data == nil {
                    self.eventHandler?(.error(response?.description ?? "some error"))
                    print("client Error")
                }
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    print("Server error")
                    return
                }
                guard let mime = response.mimeType, mime == "application/json" else {
                    print("wrong mime type")
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(SessionID.self, from: data!)
                    print(response.sessionID)
                    self.sessionID = response
                    print("sess ID:", self.sessionID?.sessionID)
                    UserDefaultsContainer.session = self.sessionID?.sessionID ?? ""
                    self.eventHandler?(.login)
                } catch {
                    print("JSON error: \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }
    
    
    // MARK: - Delete session
    
    func deleteSession() {
        var session = URLSession.shared
        let url = URL(string: "https://api.themoviedb.org/3/authentication/session?api_key=" + apiKey)
        var request = URLRequest(url: url!)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let parameters = ["session_id": UserDefaultsContainer.session]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        
        let task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if error != nil || data == nil {
                    print("client Error")
                }
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    print("Server error")
                    return
                }
                print(response.statusCode)
                guard let mime = response.mimeType, mime == "application/json" else {
                    print("wrong mime type")
                    return
                }
                print(response.statusCode)
                UserDefaultsContainer.unregister()
                self.eventHandler?(.back)
            }
        }
        task.resume()
    }
    
    private func request<T: Codable>(route: Route,
                                     model: T?,
                                     method: HTTPMethod,
                                     completion: ((Result<Codable, Error>) -> Void)?) {
        AF.request(route.url,
                   method: method,
                   parameters: model,
                   encoder: self.encoder,
                   headers: [Headers.contentType: Headers.value])
          .responseDecodable(of: <#T##Decodable.Protocol#>, queue: <#T##DispatchQueue#>, decoder: <#T##DataDecoder#>, completionHandler: <#T##(DataResponse<Decodable, AFError>) -> Void#>)
    }
}
