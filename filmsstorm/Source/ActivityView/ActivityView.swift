//
//  ActivityView.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 20.01.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

protocol ActivityViewPresenter {
    var loadingView: ActivityView { get }
}

extension ActivityViewPresenter where Self: UIViewController {
    func hideActivity() {
        self.loadingView.stopLoader()
    }
    
    func showActivity() {
        self.loadingView.startLoader(from: self.view)
    }
}

class ActivityView: UIView {
    
    private var activityIndicator = UIActivityIndicatorView()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupLoader()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLoader()
    }
    
    deinit {
        print(type(of: self))
    }
    
    private func setupLoader() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.activityIndicator)
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.style = .large
    }
    
    func startLoader(from insideView: UIView? = nil) {
        print("start loader")
        insideView.map {
            
            $0.addSubview(self)
            let views = ["view": self]
            let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|",
                                                                       options: .init(rawValue: UInt(0)),
                                                                       metrics: nil,
                                                                       views: views)
            $0.addConstraints(horizontalConstraints)
            
            let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|",
                                                                     options: .init(rawValue: UInt(0)),
                                                                     metrics: nil,
                                                                     views: views)
            $0.addConstraints(verticalConstraints)
            
            self.activityIndicator.center = $0.center
            self.activityIndicator.startAnimating()
        }
    }
    
    func stopLoader() {
        print("stop loader")
        self.removeFromSuperview()
        self.activityIndicator.stopAnimating()
    }
}
