//
//  UITextField+Extension.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 04.05.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

extension UITextField {
    func setIcon(_ image: UIImage) {
        
        let iconView = UIImageView(frame:
            CGRect(x: 10, y: 0, width: 32, height: 32))
        iconView.image = image
        
        let iconContainerView: UIView = UIView(frame:
            CGRect(x: 20, y: 0, width: 44, height: 34))
        iconContainerView.addSubview(iconView)
       
        leftView = iconContainerView
        leftViewMode = .always
    }
}
