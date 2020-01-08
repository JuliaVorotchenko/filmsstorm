//
//  SessionIDViewController.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 29.12.2019.
//  Copyright © 2019 Alexander Andriushchenko. All rights reserved.
//

import UIKit

enum SessionIDEvent: EventProtocol {
    case back
    case showSessionId
}

class SessionIDViewController: UIViewController, Controller {
    
    // MARK: - Subtypes
    
    typealias Event = SessionIDEvent
    typealias RootViewType = SessionIDView
    
    // MARK: - temporary values
    
    let apiKey = "f4559f172e8c6602b3e2dd52152aca52"
    
    // MARK: - Private properties
    
    private let networking: NetworkManager
    let eventHandler: ((SessionIDEvent) -> Void)?
    
    // MARK: - Init and deinit
    
    deinit {
        print("sessioIdContr")
    }
    
    init(networking: NetworkManager, event: ((SessionIDEvent) -> Void)?) {
        self.networking = networking
        self.eventHandler = event
        super.init(nibName: String(describing: type(of: self)), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.rootView?.fillLabel()
    }
    
    // MARK: - IBActions
    
    @IBAction func backButtonTaapped(_ sender: Any) {
        
    }
    
    // MARK: Networking
    /*
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
 */
}
