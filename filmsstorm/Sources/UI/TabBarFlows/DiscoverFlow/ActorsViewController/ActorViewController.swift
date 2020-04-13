//
//  AcorsViewController.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 12.04.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class ActorViewController<T: ActorViewPresenter>: UIViewController, Controller, ActivityViewPresenter, UICollectionViewDelegate {
    
    // MARK: - Subtypes
    
    typealias Service = T
    typealias RootViewType = ActorView
    
    enum Section: CaseIterable {
        case actor
        case actorsMedia
    }
    
    enum ActorContainer: Hashable {
        case actor(ActorDetailsModel)
        case actorsMedia(DiscoverCellModel)
    }
    
    // MARK: - Properties
    var loadingView = ActivityView()
    let presenter: Service
    
    private lazy var dataSource = self.createDataSource()
    
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
        self.getActorDetails()
        self.getActorCredits()
    }
    
    // MARK: - Private methods
    
    private func setupNavigationView() {
        self.rootView?.navigationView.actionHandler = { [weak self] in
            self?.presenter.onBack()
        }
        guard let actorName = self.presenter.actorModel.actorName else { return }
        self.rootView?.navigationView.titleFill(with: actorName)
        
    }
    
    private func getActorDetails() {
        self.presenter.getActorDetails { [weak self] result in
            self?.update(for: .actor, with: [.actor(result)])
        }
    }
    
    private func getActorCredits() {
        self.presenter.getActorCredits { [weak self] result in
            self?.update(for: .actorsMedia, with: result.map(ActorContainer.actorsMedia))
        }
    }
    
    // MARK: - Private Methods for CollectionView
    
    private func setCollectionView() {
        let collection = self.rootView?.collectionView
        collection?.register(ActorDescriptionCell.self)
        collection?.register(MediaItemImageCell.self)
        collection?.registerHeader(SectionHeaderView.self)
        collection?.setCollectionViewLayout(self.createCompositionalLayout(), animated: false)
        collection?.delegate = self
    }
    
    private func update(for section: Section, with items: [ActorContainer]) {
        var snapshot = self.dataSource?.snapshot()
        snapshot?.appendItems(items, toSection: section)
        snapshot.map { self.dataSource?.apply($0, animatingDifferences: false)}
    }
    
       func createDataSource() -> UICollectionViewDiffableDataSource<Section, ActorContainer>? {
        
        let dataSource: UICollectionViewDiffableDataSource<Section, ActorContainer>? =
            self.rootView?.collectionView
                .map { collectionView in UICollectionViewDiffableDataSource(collectionView: collectionView) {
                    [weak self] collectionView,
                    indexPath, item -> UICollectionViewCell in
                    
                    switch item {
                    case .actor(let model):
                        let cell: ActorDescriptionCell = collectionView.dequeueReusableCell(ActorDescriptionCell.self,
                                                                                               for: indexPath)
                        cell.fill(with: model)
                        return cell
                        
                    case .actorsMedia(let model):
                        let cell: MediaItemImageCell = collectionView.dequeueReusableCell(MediaItemImageCell.self,
                                                                                          for: indexPath)
                        cell.similarsFill(model: model)
                        return cell
                        
                    }
                    }
                    
        }
        var snapshot = NSDiffableDataSourceSnapshot<Section, ActorContainer>()
        snapshot.appendSections(Section.allCases)
        Section.allCases.forEach { snapshot.appendItems([], toSection: $0)}
        
        dataSource?.supplementaryViewProvider = { [weak self] in self?.supplementaryViewProvider(collectionView: $0,
                                                                                                 kind: $1,
                                                                                                 indexPath: $2) }
        dataSource?.apply(snapshot, animatingDifferences: false)
        
        return dataSource
    }
    
   private func supplementaryViewProvider(collectionView: UICollectionView,
                                           kind: String,
                                           indexPath: IndexPath) -> UICollectionReusableView? {
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: SectionHeaderView.reuseIdentifier,
            for: indexPath) as? SectionHeaderView
        
        switch Section.allCases[indexPath.section] {
        case .actor: break
        case .actorsMedia:
            header?.fill(with: "Actors Movies")
        }
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.dataSource?.itemIdentifier(for: indexPath)
        model.map {
            switch $0 {
            case .actor: break
            case .actorsMedia(let model):
                self.presenter.onMediaItem(with: model)
            }
        }
    }
    
    // MARK: - Setup Layout
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, _) -> NSCollectionLayoutSection? in
            let section = Section.allCases[sectionIndex]
            switch section {
            case .actor:
                return CollectionLayoutFactory.mediaItemDescriptionSection()
            case .actorsMedia:
                return CollectionLayoutFactory.mediaItemImagesSections()
            }
        }
        return layout
    }
}
