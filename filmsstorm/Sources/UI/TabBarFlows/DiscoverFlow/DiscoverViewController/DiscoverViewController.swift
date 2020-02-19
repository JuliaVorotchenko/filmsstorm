//
//  SessionIDViewController.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 29.12.2019.
//  Copyright © 2019 Alexander Andriushchenko. All rights reserved.
//

import UIKit

enum DiscoverEvent: EventProtocol {
    case logout
    case error(AppError)
}

class DiscoverViewController: UIViewController, Controller, ActivityViewPresenter {
    
    // MARK: - Subtypes
    
    typealias RootViewType = DiscoverView
    
    enum Section: CaseIterable {
        case  main
    }
    
    // MARK: - Public Properties
    
    let eventHandler: ((DiscoverEvent) -> Void)?
    let loadingView = ActivityView()
    
    // MARK: - Private properties
    
    private let networking: NetworkManager
    private var sections = [MovieListResult]()
    private var dataSource: UICollectionViewDiffableDataSource<Section, MovieListResult>?
    
    // MARK: - Init and deinit
    
    deinit {
        self.hideActivity()
        print(F.toString(Self.self))
    }
    
    init(networking: NetworkManager, event: ((DiscoverEvent) -> Void)?) {
        self.networking = networking
        self.eventHandler = event
        super.init(nibName: F.toString(type(of: self)), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setCollectionView()
        self.rootView?.collectionView.register(DiscoverCollectionViewCell.self)
        self.getPopularMovies()
        self.createDataSource()
        self.setupHeader()
    }
    
    // MARK: - IBActions
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        
    }
    
    // MARK: - Private Methods
    
    private func getPopularMovies() {
        self.networking.getPopularMovies { [weak self] result in
            switch result {
            case .success(let model):
                self?.sections = model.results
                self?.createDataSource()
            case .failure(let error):
                self?.eventHandler?(.error(.networkingError(error)))
            }
        }
    }
    
    private func setCollectionView() {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.455),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalHeight(0.495))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        let spacing = CGFloat(6)
        group.interItemSpacing = .fixed(spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.interGroupSpacing = 0
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 7, bottom: 0, trailing: 7)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        self.rootView?.collectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    private func setupHeader() {
        let model = DiscoverHeaderModel { [weak self] in self?.onHeaderEvents($0) }
        self.rootView?.headerView.fill(with: model)
    }
    
    private func onHeaderEvents(_ event: DiscoverHeaderEvent) {
        switch event {
        case .onSearch:
            print("search")
        case .onTVShow:
            print("TV")
        case .onMovie:
            print("mov")
        }
    }
    
    // MARK: - set diffableDatasource
    
    func createDataSource() {
        
        guard let collectionView = self.rootView?.collectionView else { return }
        self.dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { collection, indexPath, item -> UICollectionViewCell? in
            let cell: DiscoverCollectionViewCell = collection.dequeueReusableCell(DiscoverCollectionViewCell.self, for: indexPath)
            cell.fill(with: item)
            return cell
        }
        let snapshot = self.createSnapshot()
        self.dataSource?.apply(snapshot)
        
    }
    
    func createSnapshot() -> NSDiffableDataSourceSnapshot<Section, MovieListResult> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, MovieListResult>()
        snapshot.appendSections([.main])
        snapshot.appendItems(self.sections)
        return snapshot
    }
}
