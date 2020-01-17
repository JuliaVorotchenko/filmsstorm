//
//  UIViewControllerExtension.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 17.01.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

private var activityView: UIView?

extension UIViewController {
    
    func showSpinner() {
        activityView = UIView(frame: self.view.bounds)
        guard let activityIndicatorView = activityView else { return }
        activityIndicatorView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = activityIndicatorView.center
        activityIndicator.startAnimating()
        activityIndicatorView.addSubview(activityIndicator)
        self.view.addSubview(activityIndicatorView) 
        
    }
    
    func hideSpinner() {
        activityView?.removeFromSuperview()
        activityView = nil
    }
}
