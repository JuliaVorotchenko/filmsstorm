//
//  UIView+Exensions.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 28.02.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

extension UIView {
    
    func addShadow(color: UIColor = .black,
                   offset: CGSize = CGSize(width: 0.0, height: 0.0),
                   opacity: Float = 0.2,
                   radius: Float = 2.0,
                   shadowRect: CGRect? = nil) {
        
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = CGFloat(radius)
        self.layer.masksToBounds = false
        if let shadowRect = shadowRect {
            self.layer.shadowPath = UIBezierPath(rect: shadowRect).cgPath
        }
        
    }
        
    func roundedWithHeight() {
        self.rounded(cornerRadius: self.frame.size.height / 2)
    }
    
    func roundedWithWidth() {
        self.rounded(cornerRadius: self.frame.size.width / 2)
    }
    
    func rounded(cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }
}
