//
//  SearchViewController.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 24.02.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class SearchViewController<T: SearchPresenter>: UIViewController, Controller, ActivityViewPresenter, UISearchBarDelegate {
    
    // MARK: - Subtypes
    
    typealias RootViewType = SearchView
    typealias Service = T
    
    enum Section: CaseIterable {
        case  main
    }
    
    // MARK: - Private Properties
    
    let loadingView = ActivityView()
    let presenter: Service
    private var items = [DiscoverCellModel]()
    private var dataSource: UICollectionViewDiffableDataSource<Section, DiscoverCellModel>?
    let searchConroller = UISearchController(searchResultsController: nil)
    
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
        self.setupNavigationView()
        self.rootView?.searchBar?.delegate = self
        self.multiSearch(query: "Devs")
    }
    
    // MARK: - Private Methods
    
    private func multiSearch(query: String) {
        self.presenter.multiSearch(query) { result in
            self.items = result.map(DiscoverCellModel.create)

        }
    }
    
    private func setupNavigationView() {
        self.rootView?.navigationView?.actionHandler = { [weak self] in
            self?.presenter.onBack()
        }
        self.rootView?.navigationView?.titleFill(with: "Search")
    }

    // MARK: - SearcBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
}
