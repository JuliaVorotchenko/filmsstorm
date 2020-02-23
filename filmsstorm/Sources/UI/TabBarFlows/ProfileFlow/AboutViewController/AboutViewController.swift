//
//  AboutViewController.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 09.02.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

enum AboutEvent: EventProtocol {
    case profile
}

class AboutViewController: UIViewController, ActivityViewPresenter, Controller {
    
    // MARK: - Subtypes
    
    typealias Event = AboutEvent
    typealias RootViewType = AboutView
    
    // MARK: - VC lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customNavViewSetup()
    }
    
    // MARK: - Public Properties
    
    let loadingView = ActivityView()
    let eventHandler: ((AboutEvent) -> Void)?
    
    // MARK: - Private properties
    
    private let networking: NetworkManager
    
    // MARK: - Init & deinit
    
    init(networking: NetworkManager, event: ((AboutEvent) -> Void)?) {
        self.eventHandler = event
        self.networking = networking
        super.init(nibName: F.toString(type(of: self)), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print(Self.self)
    }
    
    // MARK: - Private methods
    
    private func customNavViewSetup() {
        self.rootView?.navigationView.actionHandler = { [weak self] in
            self?.onBackEvent()
        }
    }
    
    private func onBackEvent() {
        self.eventHandler?(.profile)
    }
    
}
