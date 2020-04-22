//
//  FavouritesViewController.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 25.02.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

enum Section: String, CaseIterable {
    case moviesWatchlist
    case showsWatchlist
    case favouriteMovies
    case favoriteShows
}

class FavouritesViewController<T: FavouritesPresenter>: UIViewController, Controller, UICollectionViewDelegate {
    
    // MARK: - Subtypes
    
    typealias RootViewType = FavouritesView
    typealias Service = T
    
    // MARK: - Properties

    let presenter: Service
    
    private lazy var dataSource = self.createDataSource()

    private var moviesWatchList = [DiscoverCellModel]()
    private var showsWatchlist = [DiscoverCellModel]()
    private var favoriteMovies = [DiscoverCellModel]()
    private var favoriteShows = [DiscoverCellModel]()

    // MARK: - Init and deinit
    
    deinit {
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
        self.setCollectionView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getMoviesWatchlist()
        self.getShowsWatchlist()
        self.getFavoriteMovies()
        self.getFavoriteShows()
    }

    // MARK: - Private methods to retrieve lists
    
    private func getMoviesWatchlist() {
        self.presenter.getMoviesWatchlist {  [weak self] models in
            self?.moviesWatchList = models
            self?.update()
        }
    }
    
    private func getShowsWatchlist() {
        self.presenter.getShowsWatchList {  [weak self] models in
            self?.showsWatchlist = models
            self?.update()
        }
    }
    
    private func getFavoriteMovies() {
        self.presenter.getFavoriteMovies {  [weak self] models in
            self?.favoriteMovies = models
            self?.update()
        }
    }
    
    private func getFavoriteShows() {
        self.presenter.getFavoriteShows {  [weak self] models in
            self?.favoriteShows = models
            self?.update()
        }
    }
    
    // MARK: - Private Methods for CollectionView
    
    private func setCollectionView() {
        let collection = self.rootView?.collectionView
        collection?.register(MediaItemImageCell.self)
        collection?.registerHeader(SectionHeaderView.self)
        collection?.setCollectionViewLayout(self.createCompositionalLayout(), animated: false)
        collection?.delegate = self
    }

    private func update() {
        // I didn't like to add empty snapshot to clear dataSource.
        self.dataSource?.apply(.empty(Section.allCases))
        var snapshot = NSDiffableDataSourceSnapshot<Section, DiscoverCellModel>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(self.moviesWatchList, toSection: .moviesWatchlist)
        snapshot.appendItems(self.showsWatchlist, toSection: .showsWatchlist)
        snapshot.appendItems(self.favoriteMovies, toSection: .favouriteMovies)
        snapshot.appendItems(self.favoriteShows, toSection: .favoriteShows)
        self.dataSource?.apply(snapshot, animatingDifferences: false)
    }

    func createDataSource() -> UICollectionViewDiffableDataSource<Section, DiscoverCellModel>? {

        let collection = self.rootView?.collectionView
        let dataSource: UICollectionViewDiffableDataSource<Section, DiscoverCellModel>? = collection.map {
            UICollectionViewDiffableDataSource<Section, DiscoverCellModel>(collectionView: $0) { (collectionView, indexPath, item) -> UICollectionViewCell? in
                let cell: MediaItemImageCell = collectionView.dequeueReusableCell(MediaItemImageCell.self, for: indexPath)
                cell.similarsFill(model: item)
                return cell
            }
        }
        dataSource?.supplementaryViewProvider = { [weak self] in self?.supplementaryViewProvider(collectionView: $0, kind: $1, indexPath: $2)
        }
        dataSource?.apply(.empty(Section.allCases), animatingDifferences: false)
        
        return dataSource
    }

    private func supplementaryViewProvider(collectionView: UICollectionView,
                                           kind: String,
                                           indexPath: IndexPath) -> UICollectionReusableView? {

        print(#function)
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: SectionHeaderView.reuseIdentifier,
            for: indexPath) as? SectionHeaderView

        let sectionModel = Section.allCases[indexPath.section]
        let result = SectionHeaderModel(section: sectionModel, action: { [weak self] in self?.presenter.onHeader($0) })

        header?.fill(with: result)

        return header
    }

    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.dataSource?.itemIdentifier(for: indexPath)
        model.map(self.presenter.onMedia)
    }
    
    // MARK: - Setup Layout
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (_, _) -> NSCollectionLayoutSection? in
             return CollectionLayoutFactory.mediaItemImagesSections()
        }
        return layout
    }
}

extension NSDiffableDataSourceSnapshot {
    static func empty(_ sections: [SectionIdentifierType]) -> Self {
        var snapshot = NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>()
        snapshot.appendSections(sections)
        sections.forEach { snapshot.appendItems([], toSection: $0)}
        return snapshot
    }
}
