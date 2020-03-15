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
    
    enum Section: Int {
        case main = 0
        case overview = 1
        case similars = 2
        case actors = 3
    }
    
    // MARK: - Private properties
    
    let loadingView = ActivityView()
    let presenter: Service
    private var sections = [DiscoverCellModel]()
    private var dataSource: UICollectionViewDiffableDataSource<Section, DiscoverCellModel>?
    
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
       
    }
    
    // MARK: - Private methods
    
    
    private func setupNavigationView() {
        
        self.rootView?.navigationView?.actionHandler = { [weak self] in
            self?.presenter.onBack()
        }
        let item = self.presenter.itemModel
        self.rootView?.navigationView?.titleFill(with: item.name ?? "oops")
        
    }
    
    private func setCollectionView() {
        let collectionView = self.rootView?.collectionView
        collectionView?.register(ItemOverviewViewCell.self)
        collectionView?.register(ItemDescriptionViewCell.self)
        collectionView?.register(ImageViewCell.self)
        collectionView?.delegate = self
    }

    
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { sectionNumber, env -> NSCollectionLayoutSection? in
            
            switch Section(rawValue: sectionNumber) {
            case .main:
                return self.mainSection()
            case .overview:
                return self.overviewSection()
            case .similars:
                return self.similarsSection()
            case .actors:
                return self.similarsSection()
            default:
                return nil
            }
        }
    }
    
    
    
    private func mainSection() -> NSCollectionLayoutSection {
        let sectionWidth = self.view.bounds.width
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(sectionWidth),
                                              heightDimension: .absolute(248))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(sectionWidth),
                                               heightDimension: .absolute(248))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        
        return NSCollectionLayoutSection(group: group)
    }
    
    private func overviewSection() -> NSCollectionLayoutSection {
        let sectionWidth = self.view.bounds.width
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(sectionWidth),
                                              heightDimension: .absolute(170))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(sectionWidth),
                                               heightDimension: .absolute(248))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        
        return NSCollectionLayoutSection(group: group)
    }
    
    private func similarsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitem: item, count: 3)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        let sectionHeader = self.createHeaderSection()
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    private func createHeaderSection() -> NSCollectionLayoutBoundarySupplementaryItem {
        let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93),
                                                       heightDimension: .estimated(20))
        let layout = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionHeaderSize,
                                                                 elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        return layout
    }
    
    func createDataSource() {
        guard let collectionView = self.rootView?.collectionView else { return }
        
         self.dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { [weak self ] collection, indexPath, item -> UICollectionViewCell? in
            
            
            let imageCell: ImageViewCell = collection.dequeueReusableCell(ImageViewCell.self, for: indexPath)
            imageCell.fill(model: (self?.presenter.itemModel)!)
            return imageCell
        }
        let snapshot = self.createSnapshot()
        self.dataSource?.apply(snapshot)
    }
    
    func createSnapshot() -> NSDiffableDataSourceSnapshot<Section, DiscoverCellModel> {
        var snapShot = NSDiffableDataSourceSnapshot<Section, DiscoverCellModel>()
        snapShot.appendSections([.main, .overview, .similars, .actors])
        snapShot.appendItems(self.sections)
        return snapShot
    
}

}
