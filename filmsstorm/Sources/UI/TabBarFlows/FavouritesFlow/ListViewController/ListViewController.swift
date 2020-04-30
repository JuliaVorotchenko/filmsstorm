//
//  ListViewController.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 30.04.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class ListViewController<T: ListViewPresenter>: UIViewController, Controller, ActivityViewPresenter, UITableViewDelegate {
    
    // MARK: - Subtypes
    
    typealias Service = T
    typealias RootViewType = ListView
    
    enum Section: CaseIterable {
        case main
    }
    
    // MARK: - Properties
    
    let loadingView = ActivityView()
    let presenter: T
    private var items = [DiscoverCellModel]()
    private var dataSource: UITableViewDiffableDataSource<Section, DiscoverCellModel>?
    
    // MARK: - Init and deinit
    
    deinit {
        self.hideActivity()
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
        self.createDataSource()
    }
    
    // MARK: - Private methods
   
    
    private func navigationViewSetup() {
        self.rootView?.navigationView?.actionHandler = { [weak self] in
            self?.presenter.back()
        }
    }
    
    private func setTableView() {
        self.rootView?.tableView.register(ListTableViewCell.self)
        self.rootView?.tableView.delegate = self
    }
    // MARK: - Private Methods for table view
    
    private func createDataSource() {
        guard let tableView = self.rootView?.tableView else { return }
        
        self.dataSource = UITableViewDiffableDataSource(tableView: tableView) { [weak self] tableView, indexPath, item -> UITableViewCell? in
            let cell: ListTableViewCell =
                tableView.dequeueReusableCell(ListTableViewCell.self, for: indexPath)
            cell.fill(with: item)
            return cell
        }
        let snapshot = self.createSnapShot()
        self.dataSource?.apply(snapshot)
    }
    
    func createSnapShot() -> NSDiffableDataSourceSnapshot<Section, DiscoverCellModel> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, DiscoverCellModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(self.presenter.items)
        
        return snapshot
    }
    
    // MARK: - TableView delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.presenter.items[indexPath.row]
        self.presenter.onMedia(item: model)
    }
    
}
