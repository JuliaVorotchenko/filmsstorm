//
//  SearchViewController.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 24.02.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class SearchViewController<T: SearchPresenterImpl>: UIViewController, Controller, ActivityViewPresenter {
    
    // MARK: - Subtypes
    
    typealias RootViewType = SearchView
    typealias Service = T
    
    enum Section: CaseIterable {
        case  main
    }
    
    // MARK: - Private Properties
    
    internal let loadingView = ActivityView()
    internal let presenter: Service
    private var sections = [MovieListResult]()
    private var dataSource: UICollectionViewDiffableDataSource<Section, MovieListResult>?
    
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
    
    // MARK: - Private Methods
    private func onCardEvent(_ event: MovieCardEvent) {
        switch event {
        case .like:
            F.Log("you liked movie")
        case .favourites:
            F.Log("you added moview to favourites")
        }
    }
    
    private func setupNavigationView() {
        self.rootView?.navigationView?.actionHandler = { [weak self] in
            self?.presenter.onBack()
        }
        self.rootView?.navigationView?.titleFill(with: "Search")
    }
}