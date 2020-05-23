//
//  ListViewController.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 30.04.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class ListViewController<T: ListsPresenter>: UIViewController, Controller, UITableViewDelegate {
    
    // MARK: - Subtypes
    
    typealias Service = T
    typealias RootViewType = ListView
    typealias DataSource = ListTableViewProvider
    
    enum Section: CaseIterable {
        case main
    }
    
    // MARK: - Properties
    
    let presenter: T
    private lazy var dataSource = self.rootView?.tableView
    .map { DataSource(tableView: $0) { [weak self] in self?.bindAction(model: $0) }}
    
    // MARK: - Init and deinit
    
    deinit {
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
        self.navigationViewSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.retrieveModels()
    }
    
    // MARK: - View Setup
    
    private func navigationViewSetup() {
        self.rootView?.navigationView?.actionHandler = { [weak self] in
            self?.presenter.back()
        }
        self.rootView?.navigationView.titleFill(with: self.presenter.title)
    }
    
    // MARK: - Rerieve models
    
    private func retrieveModels() {
        self.presenter.getItems { [weak self] model in
            self?.dataSource?.items = model
            self?.dataSource?.update(with: model)
        }
    }
    
    func bindAction(model: DiscoverCellModel) {
        self.presenter.onMedia(item: model)
    }
}
