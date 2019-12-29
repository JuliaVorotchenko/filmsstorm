//
//  AuthorizationViewController.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 29.12.2019.
//  Copyright © 2019 Alexander Andriushchenko. All rights reserved.
//

import UIKit

enum AuthEvent {
    case login
    case error(String)
}


class AuthorizationViewController: UIViewController {
    
    private let networking: Networking
    private let eventHandler: ((AuthEvent) -> ())?
    
    @IBOutlet var rootView: AuthorizationView?
    
    init(networking: Networking, event: ((AuthEvent) -> ())?) {
        self.networking = networking
        self.eventHandler = event
        super.init(nibName: String(describing: type(of: self)), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
   
    @IBAction func buttonTapped(_ sender: Any) {
        self.eventHandler?(.login)
    }
}
