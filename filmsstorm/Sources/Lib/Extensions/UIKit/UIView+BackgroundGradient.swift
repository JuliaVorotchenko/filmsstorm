//
//  UIView+BackgroundGradient.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 03.03.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

import UIKit

extension UIView {

    // by default
    // vertical linear gradient
    func setBackgroundGradient(colors: [UIColor],
                               start: Gradient.Point = .topLeft,
                               end: Gradient.Point = .bottomLeft,
                               type: CAGradientLayerType = .axial
    ) {
        let newColors = colors.map { $0.cgColor }
        let coloredLayer = CAGradientLayer()

        coloredLayer.frame = self.bounds
        coloredLayer.startPoint = start.point
        coloredLayer.endPoint = end.point
        coloredLayer.colors = newColors
        coloredLayer.locations = (0..<colors.count).map(NSNumber.init)
        coloredLayer.type = type

        let first = self.layer
            .sublayers?
            .enumerated()
            .first { ($0.element as? CAGradientLayer) != nil }

        if let gradient = first {
            self.layer.sublayers?.replace(object: coloredLayer, at: gradient.offset)
        } else {
            self.layer.insertSublayer(coloredLayer, at: 0)
        }
    }
}

enum Gradient {

    //  points to define gradient direction
    enum Point {
        case topLeft
        case bottomLeft
        case topRight
        case bottomRight

        case midLeft
        case midRight
        case midTop
        case midBottom

        case center

        case custom(CGPoint)

        var point: CGPoint {
            switch self {
            case .topLeft: return CGPoint(x: 0.0, y: 0.0)
            case .bottomLeft: return CGPoint(x: 0.0, y: 1.0)
            case .topRight: return CGPoint(x: 1.0, y: 0.0)
            case .bottomRight: return CGPoint(x: 1.0, y: 1.0)

            case .midLeft: return CGPoint(x: 0, y: 0.5)
            case .midRight: return CGPoint(x: 1.0, y: 0.5)
            case .midTop: return CGPoint(x: 0.5, y: 0)
            case .midBottom: return CGPoint(x: 0.5, y: 1.0)

            case .center: return CGPoint(x: 0.5, y: 0.5)

            case .custom(let point): return point
            }
        }
    }
}
