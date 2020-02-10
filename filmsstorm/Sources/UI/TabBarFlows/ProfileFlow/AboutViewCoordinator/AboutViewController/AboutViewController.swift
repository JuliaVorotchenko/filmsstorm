//
//  AboutViewController.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 09.02.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

enum AboutEvent: EventProtocol {
    case backToProfile
}


class AboutViewController: UIViewController, ActivityViewPresenter, Controller {
    typealias Event = ProfileEvent
    

    // MARK: - Subtypes
   
    typealias RootViewType = AboutView
    
    // MARK: - Public Properties
    
    let loadingView = ActivityView()
    let eventHandler: ((ProfileEvent) -> Void)?
    let aboutEvent: ((AboutEvent) -> Void)?
    
    // MARK: - IBActions

    @IBAction func backToProfile(_ sender: Any) {
        self.aboutEvent?(.backToProfile)
    }
    
    // MARK: - Private properties
    private let networking: NetworkManager
    
    // MARK: - IBActions
    
    init(networking: NetworkManager, event: ((ProfileEvent) -> Void)?, aboutEvent: ((AboutEvent) -> Void)?) {
         self.eventHandler = event
        self.networking = networking
        self.aboutEvent = aboutEvent
        super.init(nibName: F.toString(type(of: self)), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print(Self.self)
    }
    
    // MARK: - VC lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
