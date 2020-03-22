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
        case similars
        case actors
    }
    
    let elementKind = "sectionHeader"
    
    // MARK: - Private properties
    
    let loadingView = ActivityView()
    let presenter: Service
    private var sections = [DiscoverCellModel]()
    private var dataSource: UICollectionViewDiffableDataSource<Section, DiscoverCellModel>?
    
    var itemDetails: MediaItemModel?
    
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
        getItemDetails()
        
    }
    
    // MARK: - Private methods
    
    private func getItemDetails() {
        let item = self.presenter.itemModel
        self.presenter.getItemDetails { model in
            print(model.originalName, model.genre)
            self.rootView?.descriptionView.fill(model: model)
        }
    }
    
    
    private func setupNavigationView() {
        self.rootView?.navigationView?.actionHandler = { [weak self] in
            self?.presenter.onBack()
        }
        let item = self.presenter.itemModel
        self.rootView?.navigationView?.titleFill(with: item.name ?? "oops")
    }
    
    private func setCollectionView() {
        let layout = self.createLayout()
        let collectionView = self.rootView?.collectionView
        collectionView?.setCollectionViewLayout(layout, animated: true)
        collectionView?.delegate = self
        collectionView?.register(ImageViewCell.self)
        collectionView?.register(SectionHeaderView.self, forSupplementaryViewOfKind: self.elementKind,
                                 withReuseIdentifier: SectionHeaderView.reuseIdentifier)
        self.createDataSource()
    }
    
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { sectionNumber, env -> NSCollectionLayoutSection? in
            if sectionNumber == 0 {
                return self.similarsSection()
            } else {
                return self.similarsSection()
            }
        }
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
        
        //        let sectionHeader = self.createHeaderSection()
        //        section.boundarySupplementaryItems = [sectionHeader]
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
        
        self.dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { [weak self] collection, indexPath, item -> UICollectionViewCell? in
            
            let imageCell: ImageViewCell = collection.dequeueReusableCell(ImageViewCell.self, for: indexPath)
            imageCell.fill(model: item)
            return imageCell
        }
        
        //        self.dataSource?.supplementaryViewProvider = { [weak self] (collectionView: UICollectionView,
        //            kind: String,
        //            indexPath: IndexPath) -> UICollectionReusableView? in
        //
        //            if kind == self?.elementKind {
        //                if let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
        //                                                                                    withReuseIdentifier: SectionHeaderView.reuseIdentifier,
        //                                                                                    for: indexPath) as? SectionHeaderView {
        //                    headerView.title.text = "Similars"
        //                  return headerView
        //                }
        //            }
        //
        //        }
        
        let snapshot = self.createSnapshot()
        self.dataSource?.apply(snapshot)
    }
    
    func createSnapshot() -> NSDiffableDataSourceSnapshot<Section, DiscoverCellModel> {
        var snapShot = NSDiffableDataSourceSnapshot<Section, DiscoverCellModel>()
        snapShot.appendSections([.similars, .actors])
        snapShot.appendItems(self.sections)
        return snapShot
        
    }
    
}
