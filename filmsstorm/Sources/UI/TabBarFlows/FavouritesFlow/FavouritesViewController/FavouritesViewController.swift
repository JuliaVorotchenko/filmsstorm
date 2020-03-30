//
//  FavouritesViewController.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 25.02.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class FavouritesViewController<T: FavouritesPresenter>: UIViewController, Controller, ActivityViewPresenter {
    
    // MARK: - Subtypes
    
    typealias RootViewType = FavouritesView
    typealias Service = T
    
    // MARK: - Private properties
    
    let loadingView = ActivityView()
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
        self.setupNavigaionView()
    }
    
    // MARK: - Private Methods
    
    private func setupNavigaionView() {
        self.rootView?.navigationView?.backButton?.isHidden = true
        self.rootView?.navigationView?.titleFill(with: "Favourites")
    }
}
