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
    
    enum Section: CaseIterable {
        case main
    }
    
    // MARK: - Properties
    
    let presenter: T
    private var items: [DiscoverCellModel] = []
    private lazy var dataSource = self.createDataSource()
    
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
        self.setTableView()
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
    
    private func setTableView() {
        self.rootView?.tableView.register(ListTableViewCell.self)
        self.rootView?.tableView.delegate = self
        self.rootView?.tableView?.dataSource = self.dataSource
    }
    
    // MARK: - Rerieve models
    
    private func retrieveModels() {
        self.presenter.getItems { [weak self] in
            self?.items = $0
            self?.update(section: Section.allCases, items: $0)
        }
    }
    
    // MARK: - Private Methods for table view
    
    private func createDataSource() -> UITableViewDiffableDataSource<Section, DiscoverCellModel>? {
        return self.rootView.map {
            UITableViewDiffableDataSource(tableView: $0.tableView) { (tableView, indexPath, item) -> UITableViewCell? in
                let cell: ListTableViewCell =
                    tableView.dequeueReusableCell(ListTableViewCell.self, for: indexPath)
                cell.fill(with: item)
                return cell
            }
        }
    }
    
    private func update(section: [Section], items: [DiscoverCellModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, DiscoverCellModel>()
        snapshot.appendSections(section)
        snapshot.appendItems(items)
        self.dataSource?.apply(snapshot)
    }
    
    // MARK: - TableView delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.items[indexPath.row]
        self.presenter.onMedia(item: model)
    }
}
