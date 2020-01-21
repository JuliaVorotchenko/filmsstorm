//
//  ActivityView.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 20.01.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

protocol ActivityViewPresenter {
    var loadingView: ActivityView? { get }
}

class ActivityView: UIView {

    private var activityIndicator = UIActivityIndicatorView()
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLoader()
    }

   
    public override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
       setupLoader()
    }

    
    
    private func setupLoader() {
       // translatesAutoresizingMaskIntoConstraints = false
        self.superview?.addSubview(self.activityIndicator)
        self.stopLoader()
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.style = .large
    }

    func startLoader() {
        print("start loader")
        setupLoader()
        DispatchQueue.main.async {
            if let holdingView = self.superview {
                print(holdingView.debugDescription)
                self.activityIndicator.center = holdingView.center
                self.activityIndicator.startAnimating()
            }
        }
    }
        
    func stopLoader() {
        print("stop loader")
        DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.removeFromSuperview()
        }
    }
}


