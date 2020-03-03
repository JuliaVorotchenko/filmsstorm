//
//  UIRectCorner+Extensions.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 03.03.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit


extension UIRectCorner {
    
    func toCornerMask() -> CACornerMask {
        var mask: CACornerMask = []
        if self.contains(.allCorners) {
            mask.formUnion(.layerMinXMinYCorner)
            mask.formUnion(.layerMaxXMinYCorner)
            mask.formUnion(.layerMaxXMaxYCorner)
            mask.formUnion(.layerMinXMaxYCorner)
        }
        if self.contains(.topLeft) {
            mask.formUnion(.layerMinXMinYCorner)
        }
        if self.contains(.topRight) {
            mask.formUnion(.layerMaxXMinYCorner)
        }
        if self.contains(.bottomRight) {
            mask.formUnion(.layerMaxXMaxYCorner)
        }
        if self.contains(.bottomLeft) {
            mask.formUnion(.layerMinXMaxYCorner)
        }
        
        return mask
    }
}
