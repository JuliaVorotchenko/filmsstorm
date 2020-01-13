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
//        self.networking.getUserDetails { (userModel, error) in
//            if let error = error {
//                print(error)
//            }
//            if let userModel = userModel {
//                DispatchQueue.main.async {
//                    self.rootView?.userIDLabel.text = String(userModel.id ?? 11)
//                }
//                
//            }
//        }
    }
    
    // MARK: - IBActions
    
    @IBAction func backButtonTaapped(_ sender: Any) {
        print("button tapped")
//        self.networking.logout { (logoutModel, error) in
//            if let error = error {
//                print(error)
//            }
//            if logoutModel != nil {
//                self.eventHandler?(.back)
//            }
//        }
    }
}
