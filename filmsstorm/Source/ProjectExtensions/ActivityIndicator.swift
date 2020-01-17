//
//  ActivityIndicator.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 17.01.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

extension UIViewController {
    var spinnerTag: Int { return 5555555 }
    
    func spinnerStart (style: UIActivityIndicatorView.Style = .large,
                       location: CGPoint? = nil) {
        let location = location ?? self.view.center
        DispatchQueue.main.async {
            let acticvityIndicator = UIActivityIndicatorView(style: style)
            acticvityIndicator.tag = self.spinnerTag
            acticvityIndicator.center = location
            acticvityIndicator.hidesWhenStopped = true
            acticvityIndicator.startAnimating()
            self.view.addSubview(acticvityIndicator)
        }
    }
    
    func spinnerStop() {
        DispatchQueue.main.async {
            if let activityIndicator = self.view.subviews
                .filter({ $0.tag == self.spinnerTag })
                .first as? UIActivityIndicatorView {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
            }
        }
    }
}
