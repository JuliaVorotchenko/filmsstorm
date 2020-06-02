//
//  Refresher.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 02.06.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class Refresher: UIRefreshControl {
    
    private weak var target: AnyObject?
    private var selector: Selector?
    
    // MARK: - Init & Deinit

    override init() {
        super.init()
    }
    
    convenience init(target: AnyObject?, selector: Selector?) {
        self.init()
        self.target = target
        self.selector = selector
        self.addTarget()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addTarget() {
        guard let selector = self.selector else { return }
        self.addTarget(self.target, action: selector, for: .valueChanged)
    }
}
