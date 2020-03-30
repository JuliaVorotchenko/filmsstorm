//
//  MediaItemViewController.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 25.02.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class MediaItemViewController<T: MediaItemPresenter>: UIViewController, Controller, ActivityViewPresenter, UICollectionViewDelegate {
    
    // MARK: - Subtypes
    
    typealias RootViewType = MediaItemView
    typealias Service = T
    
    enum Section: CaseIterable {
        case media
        case similars
        case actos
    }
    
    enum MediaItemContainer: Hashable {
        case media(MediaItemModel?)
        case similars(DiscoverCellModel)
        case actos(ActorModel)
    }
    
    // MARK: - Properties
    
    let sectionHeaderElementKind = "SectionHeaderView"
    
    let loadingView = ActivityView()
    let presenter: Service
    
    var mediaItemModel: MediaItemModel?
    var discoverCellModel: [DiscoverCellModel]?
    var actorModel: [ActorModel]?
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, MediaItemContainer>?
    
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
        self.setCollectionView()
        self.getMovieSimilars()
        self.getFirst()
        self.getItemDescription()
        self.createDataSource()
    }
    
    // MARK: - Private methods
    
    private func getFirst() {
        self.presenter.getMovieCast { [weak self] models in
            self?.actorModel = models
            self?.updateData()
        }
    }
    
    private func getMovieSimilars() {
        self.presenter.getMovieSimilars { [weak self] in
            self?.discoverCellModel = $0
            self?.updateData()
        }
    }
    
    private func getItemDescription() {
        self.presenter.getItemDetails { [weak self] model in
            self?.mediaItemModel = model
            self?.updateData()
        }
    }
    
    private func setupNavigationView() {
        self.rootView?.navigationView?.actionHandler = { [weak self] in
            self?.presenter.onBack()
        }
        let item = self.presenter.itemModel
        self.rootView?.navigationView?.titleFill(with: item.name ?? "N/A")
    }
    
    private func onCardEvent(_ event: ItemDescriptionEvent) {
        switch event {
        case .watchlist(let model):
            self.presenter.addToWatchList(model)
            F.Log("you added to watch list \(String(describing: model?.name)), \(String(describing: model?.mediaType))")
        case .favourites(let model):
            self.presenter.addToFavourites(model)
            F.Log("you added to favourites \(String(describing: model?.name)), \(String(describing: model?.mediaType))")
        }
    }

    // MARK: - Private Methods for CollectionView
    
    private func setCollectionView() {
        let collection = self.rootView?.collecionView
        collection?.register(MediaItemImageCell.self)
        collection?.register(ItemDescriptionViewCell.self)
        collection?.registerHeader(SectionHeaderView.self)
        collection?.setCollectionViewLayout(self.createCompositionalLayout(), animated: false)
    }
    
    private func updateData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, MediaItemContainer>()
        snapshot.appendSections([.media])
        let model = self.mediaItemModel != nil
            ? self.mediaItemModel
            : MediaItemModel.from(configure: self.presenter.itemModel)
        snapshot.appendItems([.media(model)], toSection: .media)
        
        snapshot.appendSections([.similars])
        let similars = self.discoverCellModel?.map(MediaItemContainer.similars)
        similars.map { snapshot.appendItems($0, toSection: .similars) }
        
        snapshot.appendSections([.actos])
        let actors = self.actorModel?.map(MediaItemContainer.actos)
        actors.map { snapshot.appendItems($0, toSection: .actos) }
        
        self.dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    func createDataSource() {
        guard let collectionView = self.rootView?.collecionView else { return }
        self.dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { collection, indexPath, item -> UICollectionViewCell? in
            switch item {
            case .media(let model):
                let cell: ItemDescriptionViewCell = collectionView.dequeueReusableCell(ItemDescriptionViewCell.self, for: indexPath)
                cell.fill(detailsModel: model, onAction: .init { self.onCardEvent($0) })
                return cell
            case .similars(let model):
                let cell: MediaItemImageCell = collection.dequeueReusableCell(MediaItemImageCell.self, for: indexPath)
                cell.similarsFill(model: model)
                return cell
            case .actos(let model):
                let cell: MediaItemImageCell = collection.dequeueReusableCell(MediaItemImageCell.self, for: indexPath)
                cell.actorsFill(model: model)
                return cell
            }
            
        }
        
        self.dataSource?.supplementaryViewProvider = { [weak self] in self?.supplementaryViewProvider(collectionView: $0, kind: $1, indexPath: $2) }
           
        self.updateData()
        }
    
    private func supplementaryViewProvider(collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? {
        let header = collectionView.dequeueReusableSupplementaryView(
             ofKind: kind,
                 withReuseIdentifier: SectionHeaderView.reuseIdentifier,
                 for: indexPath) as? SectionHeaderView
             
             switch Section.allCases[indexPath.section] {
             case .actos:
                 header?.fill(with: "Actors")
             case .similars:
                 header?.fill(with: "Similars")
             case .media:
                 break
             }
        
             return header
    }
        
        // MARK: - Setup Layout
        
        func createCompositionalLayout() -> UICollectionViewLayout {
            let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex, _) -> NSCollectionLayoutSection? in
                let section = Section.allCases[sectionIndex]
                switch section {
                case .actos:
                    return self?.creaeItemImageSecion()
                case .media:
                    return self?.createMediaSection()
                case .similars:
                    return self?.creaeItemImageSecion()
                }
            }
            return layout
        }
        
        func creaeItemImageSecion() -> NSCollectionLayoutSection {
            let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(128),
                                                  heightDimension: .absolute(190))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
           
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .estimated(222))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = .fixed(14)
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = .init(top: 8, leading: 14, bottom: 15, trailing: 0)
            section.interGroupSpacing = 14
            section.orthogonalScrollingBehavior = .continuous
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                    heightDimension: .estimated(20))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: self.sectionHeaderElementKind, alignment: .top)
            section.boundarySupplementaryItems = [sectionHeader]
            return section
        }
        
        func createMediaSection() -> NSCollectionLayoutSection {
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(320))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 0, bottom: 8, trailing: 0)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(1))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
}
