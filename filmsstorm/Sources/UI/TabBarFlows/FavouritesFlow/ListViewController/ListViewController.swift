//
//  ListViewController.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 30.04.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class ListViewController<T: ListViewPresenter>: UIViewController, Controller, ActivityViewPresenter, UITableViewDelegate {
    
    // MARK: - Subtypes
    
    typealias Service = T
    typealias RootViewType = ListView
    
    // MARK: - Properties
    
    let loadingView = ActivityView()
    let presenter: T
    
    // MARK: - Init and deinit
    
    deinit {
        self.hideActivity()
        F.Log(F.toString(Self.self))
    }
    
    required init(_ presenter: Service) {
        self.presenter = presenter
        super.init(nibName: F.nibNamefor(Self.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationViewSetup()
    }
    
    // MARK: - Private methods

    private func navigationViewSetup() {
        self.rootView?.navigationView?.actionHandler = { [weak self] in
            self?.presenter.back()
              }
    }
    // MARK: - Private Methods for table view
    
}
