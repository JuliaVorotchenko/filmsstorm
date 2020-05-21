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
    typealias DataSource = ActorsCollectionViewProvider
    
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
    
    private lazy var dataSource = self.rootView?
        .collectionView
        .map { DataSource(collectionView: $0) { [weak self] in self?.bindActions($0) }}
    
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
            self?.dataSource?.update(for: .actor, with: [.actor(result)])
        }
    }
    
    private func getActorCredits() {
        self.presenter.getActorCredits { [weak self] result in
            result.forEach { model in
                self?.dataSource?.update(for: .actorsMedia, with: [.actorsMedia(model)])
            }
        }
    }
    
    private func bindActions(_ event: DataSource.ActorContainer) {
        switch event {
        case .actor: break
        case .actorsMedia(let model): self.presenter.onMediaItem(with: model)
        }
    }
}
