//
//  AboutViewController.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 09.02.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit


class AboutViewController<T: AboutPresentationService>: UIViewController, ActivityViewPresenter, Controller {
    
    // MARK: - Subtypes
    
    typealias Event = AboutEvent
    typealias RootViewType = AboutView
    typealias Service = T
    
    // MARK: - VC lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customNavViewSetup()
    }
    
    // MARK: - Public Properties
    
    let loadingView = ActivityView()
    internal let presentation: Service
    
    // MARK: - Init & deinit
    
    required init(_ presentation: Service) {
        self.presentation = presentation
        super.init(nibName: F.nibNamefor(Self.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.hideActivity()
        print(F.toString(Self.self))
    }
    
    // MARK: - Private methods
    
    private func customNavViewSetup() {
        self.rootView?.navigationView.actionHandler = { [weak self] in
            self?.presentation.onBackEvent()
        }
    }
}
