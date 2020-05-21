//
//  SearchViewController.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 24.02.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class SearchViewController<T: SearchPresenter>: UIViewController, Controller, UISearchBarDelegate, UICollectionViewDelegate {
    
    // MARK: - Subtypes
    
    typealias RootViewType = SearchView
    typealias Service = T
    typealias DataSource = DiscoverCollectionViewProvider
    
    // MARK: - Private Properties
    
    let presenter: Service
    private var items = [DiscoverCellModel]()
    private var segmentedControlObserver: NSKeyValueObservation?
    private lazy var dataSource = self.rootView?.collectionView
        .map { DataSource(collectionView: $0) { [weak self] in
            self?.bindAction(model: $0)
            }}
    
    // MARK: - Init and deinit
    
    deinit {
        self.segmentedControlObserver?.invalidate()
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
        self.setupSearchBar()
        self.setSegmentedControlObserver()
    }
    
    // MARK: - Private Methods
    
    private func movieSearch(query: String) {
        self.presenter.moviesSearch(query) { result in
            self.items = result.map(DiscoverCellModel.create)
            self.dataSource?.update(with: self.items)
        }
    }
    
    private func showSearch(query: String) {
        self.presenter.showsSearch(query) { result in
            self.items = result.map(DiscoverCellModel.create)
            self.dataSource?.update(with: self.items)
        }
    }
    
    private func setupNavigationView() {
        self.rootView?.navigationView?.actionHandler = { [weak self] in
            self?.presenter.onBack()
        }
        self.rootView?.navigationView?.titleFill(with: "Search")
    }
    
    private func setupSearchBar() {
        guard let searchBar = self.rootView?.searchBar else { return }
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
    }
    
    private func setSegmentedControlObserver() {
        self.segmentedControlObserver = self.rootView?.segmentedControl.observe(\UISegmentedControl.selectedSegmentIndex, changeHandler: { [weak self] segmenedConrol, _ in
            guard let searchBarText = self?.rootView?.searchBar?.text else { return }
            
            if !searchBarText.isEmpty && segmenedConrol.selectedSegmentIndex == 1 {
                self?.dataSource?.clearDataSource()
                self?.showSearch(query: searchBarText)
            } else if !searchBarText.isEmpty && segmenedConrol.selectedSegmentIndex == 0 {
                self?.dataSource?.clearDataSource()
                self?.movieSearch(query: searchBarText)
            }
        })
    }
    
    func bindAction(model: DiscoverCellModel) {
        self.presenter.onMediaItem(item: model)
    }

    // MARK: - SearcBarDelegate
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.dataSource?.clearDataSource()
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dataSource?.clearDataSource()
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let searchQuery = self.rootView?.searchBar?.text else { return }
        guard let segmentedControl = self.rootView?.segmentedControl else { return }

        switch segmentedControl.selectedSegmentIndex {
        case 0:
            self.movieSearch(query: searchQuery)
        case 1:
            self.showSearch(query: searchQuery)
        default:
            break
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.dataSource?.clearDataSource()
        }
    }

}
