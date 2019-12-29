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
    private let eventHandler: ((AuthEvent) -> Void)?
    
    @IBOutlet var rootView: AuthorizationView?
    
    init(networking: Networking, event: ((AuthEvent) -> Void)?) {
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
        //self.eventHandler?(.login)
        login()
    }
    
    func login() {
        let session = URLSession.shared
        let url = URL(string: "https://api.themoviedb.org/3/authentication/token/new?api_key=f4559f172e8c6602b3e2dd52152aca52")!
        let task = session.dataTask(with: url) { (data, response, error) in
            print(data?.debugDescription)
            print(response.debugDescription)
            print(error.debugDescription)
        }
        task.resume()
}
}
