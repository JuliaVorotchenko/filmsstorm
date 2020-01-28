//
//  SessionIDViewController.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 29.12.2019.
//  Copyright © 2019 Alexander Andriushchenko. All rights reserved.
//

import UIKit

enum SessionIDEvent: EventProtocol {
    case back
    case showSessionId
    case error(AppError)
}

class MainViewController: UIViewController, Controller, ActivityViewPresenter {

    // MARK: - Subtypes
    
    typealias Event = SessionIDEvent
    typealias RootViewType = MainView
    
    // MARK: - Private properties
    
    private let networking: NetworkManager
    let eventHandler: ((SessionIDEvent) -> Void)?
    let loadingView = ActivityView()
    var movies: PopularMoviesModel?
    
    // MARK: - Init and deinit
    
    deinit {
    }
    
    init(networking: NetworkManager, event: ((SessionIDEvent) -> Void)?) {
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
        self.rootView?.collectionView.register(MainCollectionViewCell.self)
        self.getPopularMovies()
        
    }
    
    // MARK: - IBActions
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
           self.logout()
       }
    
    // MARK: - Private Methods
    private func setCollectionViewDelegate() {
        self.rootView?.collectionView.dataSource = self
    }
    
    private func getPopularMovies() {
        self.networking.getPopularMovies { [weak self] result in
            switch result {
            case .success(let model):
                print("getpopularMainVC", model.results[0])
                self?.movies = model
                
                self?.rootView?.collectionView.reloadData()
            case .failure(let error):
                self?.eventHandler?(.error(.networkingError(error)))
                print(error.stringDescription)
            }
        }
    }
    
    private func getUserDetails() {
        let sessionID = UserDefaultsContainer.session
        self.networking.getUserDetails(sessionID: sessionID) { [weak self] result in
            switch result {
            case .success(let usermodel):
                UserDefaultsContainer.username = usermodel.username ?? ""
                DispatchQueue.main.async {

                }
            case .failure(let error):
                self?.eventHandler?(.error(.networkingError(error)))
                print(error.stringDescription)
            }
        }
    }
    
    private func logout() {
        self.showActivity()
        let sessionID = UserDefaultsContainer.session
        self.networking.logout(sessionID: sessionID) { [weak self] result in
            switch result {
            case .success:
                UserDefaultsContainer.unregister()
                self?.eventHandler?(.back)
                self?.hideActivity()
            case .failure(let error):
                print(error.stringDescription)
                self?.hideActivity()
                self?.eventHandler?(.error(.networkingError(error)))
                
            }
        }
    }
    
    private func setCollectionView() {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.455),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalHeight(0.48))
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
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movies?.results.count ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MainCollectionViewCell = collectionView.dequeueReusableCell(MainCollectionViewCell.self, for: indexPath)
        let model = self.movies?.results[indexPath.row]
        cell.fill(with: model)
        return cell
    }

}
