//
//  Refresher.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 02.06.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

final class Refresher: NSObject {
    
    // MARK: - Properties
    
    private let refreshControl = UIRefreshControl()
    private var refreshHandler: (() -> Void)?
    
    // MARK: - Init and deinit
    
    deinit {
        F.Log(self)
        self.refreshControl.endRefreshing()
    }
    
    init(scrollView: UIScrollView, refreshHandler: (() -> Void)?) {
        self.refreshHandler = refreshHandler
        super.init()
        self.refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        scrollView.refreshControl = self.refreshControl
        
    }
    
    @objc private func refresh() {
        self.refreshHandler?()
        self.refreshControl.endRefreshing()
    }
}
