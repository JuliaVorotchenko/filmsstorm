//
//  UIView+CornerRadius.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 03.03.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

extension UIView {
    
    @IBInspectable
    var cornerPropotion: CGFloat {
        set(propoprion) {
            let side = min(self.frame.height, self.frame.width)
            
            self.layer.cornerRadius = side * propoprion
            self.layer.masksToBounds = true
        }
        
        get {
            fatalError()
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat {
        set(radius) {
            self.layer.cornerRadius = radius
            self.layer.masksToBounds = true
        }
        
        get {
            return self.layer.cornerRadius
        }
    }
    
    func setCornerRadius(color: UIColor, radius: CGFloat, forCorners: UIRectCorner) {
        if #available(iOS 11, *) {
            self.layer.cornerRadius = radius
            self.layer.maskedCorners = forCorners.toCornerMask()
        } else {
            let layer = CALayer()
            let mask = CAShapeLayer()
            let path = UIBezierPath(roundedRect: self.bounds,
                                    byRoundingCorners: forCorners,
                                    cornerRadii: CGSize(width: radius, height: radius)).cgPath
            layer.bounds = self.bounds
            mask.path = path
            layer.mask = mask
            layer.backgroundColor = color.cgColor
            
            if let image = UIImage.image(with: layer) {
                let backgroundColor = UIColor(patternImage: image)
                self.backgroundColor = backgroundColor
            }
        }
    }
    
    func setCornerRadius(_ radius: CGFloat, forCorners corners: UIRectCorner) {
        if corners.isEmpty {
            self.layer.mask = nil
        } else {
            let mask = CAShapeLayer()
            let path = UIBezierPath(roundedRect: self.bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius)).cgPath
            mask.path = path
            self.layer.mask = mask
        }
    }
}
