//
//  AcorsViewController.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 12.04.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class ActorViewController<T: ActorViewPresenter>: UIViewController, Controller, ActivityViewPresenter, UICollectionViewDelegate {
   
    // MARK: - Subtypes
    
    typealias Service = T
    typealias RootViewType = ActorView

    // MARK: - Properties
    var loadingView = ActivityView()
    let presenter: Service

     // MARK: - Init and deinit
    
    deinit {
           self.hideActivity()
           F.Log(F.toString(Self.self))
       }
    
    required init(_ presentation: Service) {
        self.presenter = presentation
        super.init(nibName: F.nibNamefor(Self.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationView()

    }
    
    // MARK: - Private methods

    private func setupNavigationView() {
        self.rootView?.navigationView.actionHandler = { [weak self] in
            self?.presenter.onBack()
        }
    }

}
