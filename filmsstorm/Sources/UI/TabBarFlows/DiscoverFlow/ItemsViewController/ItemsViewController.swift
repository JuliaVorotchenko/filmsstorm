//
//  MoviesViewController.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 24.02.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class ItemsViewController<T: ItemsPresenter>: UIViewController, Controller, UICollectionViewDelegate {
    
    // MARK: - Subtypes
    
    typealias RootViewType = MoviesView
    typealias Service = T
    typealias DataSource = DiscoverCollectionViewProvider
   
    // MARK: - Private properties
    
    let presenter: T
  
    private lazy var dataSource = self.rootView?.collectionView
    .map { DataSource(collectionView: $0) { [weak self] in self?.bindAction(model: $0) }}
    
    // MARK: - Init and deinit
    
    deinit {
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
        self.setupNavigationView()
        self.getPopularMovies()
    }
    
    // MARK: - Private Methods
    
    private func getPopularMovies() {
        self.presenter.getItems { [weak self] in
            self?.dataSource?.update(with: $0)
        }
    }
    
    private func setupNavigationView() {
        self.rootView?.navigationView?.actionHandler = { [weak self] in
            self?.presenter.onBack()
        }
        self.rootView?.navigationView?.titleFill(with: self.presenter.title)
    }
    
    func bindAction(model: DiscoverCellModel) {
        self.presenter.onMedia(item: model)
    }

}
