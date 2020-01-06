//
//  AuthorizationViewController.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 29.12.2019.
//  Copyright © 2019 Alexander Andriushchenko. All rights reserved.
//

import UIKit

enum AuthEvent: EventProtocol {
    case login
    case error(String)
}
/*
 1. Get request token with APIkey
 2. Validate request token with password and username
 3. Get sessionID
 */
class AuthorizationViewController: UIViewController, Controller {
    
    typealias Event = AuthEvent
    typealias RootViewType = AuthorizationView
    
    private let networking: Networking
    let eventHandler: ((Event) -> Void)?
    
    // MARK: - temporary variables
    let apiKey = "f4559f172e8c6602b3e2dd52152aca52"
    var token: RequestToken?
    var validToken: RequestToken?
    var sessionID: SessionID?
    // MARK: - root view
    
    // MARK: class init
    init(networking: Networking, event: ((AuthEvent) -> Void)?) {
        self.networking = networking
        self.eventHandler = event
        super.init(nibName: String(describing: type(of: self)), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: VDL
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // MARK: Buttons
    @IBAction func getTokenTapped(_ sender: Any) {
        self.getToken()
    }
    @IBAction func validateTokenTapped(_ sender: Any) {
        self.validateToken()
    }
    @IBAction func getSessionTapped(_ sender: Any) {
        self.createSessionId()
    }
    
    
    @IBAction func buttonTapped(_ sender: Any) {
        getToken()
    }
    //MARK: - Networking
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
    
    
}
