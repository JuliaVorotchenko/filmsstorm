//
//  SearchViewController.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 24.02.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class SearchViewController<T: SearchPresenter>: UIViewController, Controller, ActivityViewPresenter, UISearchBarDelegate, UICollectionViewDelegate {
    
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
    private lazy var dataSource = self.createDataSource()
    
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
        self.setupSearcBar()
        self.setCollecionView()
    }
    
    // MARK: - Private Methods
    
    private func movieSearch(query: String) {
        self.presenter.moviesSearch(query) { result in
             self.items = result.map(DiscoverCellModel.create)
             self.update(for: .main, with: self.items)
        }
    }
    
    private func showSearch(query: String) {
        self.presenter.showsSearch(query) { result in
            self.items = result.map(DiscoverCellModel.create)
            self.update(for: .main, with: self.items)
        }
    }
    
    private func setupNavigationView() {
        self.rootView?.navigationView?.actionHandler = { [weak self] in
            self?.presenter.onBack()
        }
        self.rootView?.navigationView?.titleFill(with: "Search")
    }
    
    private func setupSearcBar() {
        guard let searchBar = self.rootView?.searchBar else { return }
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
    }
    
    private func setCollecionView() {
        let collection = self.rootView?.collectionView
        let layout = CollectionLayoutFactory.standart()
        collection?.register(DiscoverCollectionViewCell.self)
        collection?.setCollectionViewLayout(layout, animated: false)
        collection?.delegate = self
    }
    
    // MARK: - Data Source
    
    private func update(for section: Section, with items: [DiscoverCellModel]) {
        var snapshot = self.dataSource?.snapshot()
        snapshot?.appendItems(items, toSection: .main)
        snapshot.map { self.dataSource?.apply($0, animatingDifferences: false)}
    }
    
    private func dataSourceCleanOut() {
        self.items = [DiscoverCellModel]()
        var snapshot = NSDiffableDataSourceSnapshot<Section, DiscoverCellModel>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(items)
        self.dataSource?.apply(snapshot, animatingDifferences: false)
    }

    func createDataSource() -> UICollectionViewDiffableDataSource<Section, DiscoverCellModel>? {
        
        let dataSource: UICollectionViewDiffableDataSource<Section, DiscoverCellModel>? =
            self.rootView?.collectionView
                .map { collectionView in UICollectionViewDiffableDataSource(collectionView: collectionView) { [weak self]
                    collectionView,
                    indexPath, item -> UICollectionViewCell in
                    
                    let cell: DiscoverCollectionViewCell = collectionView.dequeueReusableCell(DiscoverCollectionViewCell.self, for: indexPath)
                    cell.fill(with: item)
                    return cell
                    }
        }
        var snapshot = NSDiffableDataSourceSnapshot<Section, DiscoverCellModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(self.items)
        dataSource?.apply(snapshot, animatingDifferences: false)
        
        return dataSource
    }

    // MARK: - SearcBarDelegate
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
       self.dataSourceCleanOut()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.dataSourceCleanOut()
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
            self.dataSourceCleanOut()
        }
    }
    
    // MARK: - CpllecttionView Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.items[indexPath.row]
        self.presenter.onMediaItem(item: model)
    }
    
}
