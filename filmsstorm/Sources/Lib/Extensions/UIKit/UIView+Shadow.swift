//
//  UIView+Shadow.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 03.03.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

extension UIView {
    func setShadow(color: UIColor = .darkGray,
                   opacity: Float = 0.5,
                   shadowOffset: CGSize = CGSize(width: 1, height: 1),
                   radius: CGFloat = 1,
                   cornerRadius: CGFloat = 0,
                   shouldRasterize: Bool = false
    ) {
        let view = UIView(frame: self.bounds)

        view.drawShadow(color: color,
                        opacity: opacity,
                        shadowOffset: shadowOffset,
                        radius: radius,
                        cornerRadius: cornerRadius,
                        shouldRasterize: shouldRasterize)

        self.superview?.insertSubview(view, belowSubview: self)
    }

    //  used when view.clipToBounds is 'false'
    func drawShadow(color: UIColor = UIColor.darkGray,
                    opacity: Float = 0.1,
                    shadowOffset: CGSize = CGSize(width: 1, height: 1),
                    radius: CGFloat = 15,
                    cornerRadius: CGFloat = 0,
                    shouldRasterize: Bool = false
    ) {
        let layer = self.layer

        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = radius
        layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius).cgPath

        if shouldRasterize {
            layer.rasterizationScale = UIScreen.main.scale
            layer.shouldRasterize = shouldRasterize
        }
    }

    func setRoundShadow() {
        self.setShadow(color: .cyan, opacity: 0.8, shadowOffset: CGSize( width: 2.0, height: 2.0), radius: 2, cornerRadius: self.height / 2)
    }
}
