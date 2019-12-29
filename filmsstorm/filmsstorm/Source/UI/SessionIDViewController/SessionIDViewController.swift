//
//  SessionIDViewController.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 29.12.2019.
//  Copyright © 2019 Alexander Andriushchenko. All rights reserved.
//

import UIKit

enum SessionIDEvent {
    case back
    case showSessionId
}

class SessionIDViewController: UIViewController {
    
    private let networking: Networking
    private let eventHandler: ((SessionIDEvent) -> ())?
    
    @IBOutlet var rootView: SessionIDView!
    
    init(networking: Networking, event: ((SessionIDEvent) -> ())?) {
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
    @IBAction func backButtonTaapped(_ sender: Any) {
        self.eventHandler?(.back)
    }
    
}
