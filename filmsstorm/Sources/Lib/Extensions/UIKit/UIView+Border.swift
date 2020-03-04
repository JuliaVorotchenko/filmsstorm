//
//  UIView+Border.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 03.03.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

extension UIView {
    @IBInspectable
    var borderColor: UIColor? {
        set(color) {
            self.layer.borderColor = color?.cgColor
        }

        get {
            return self.layer.borderColor.map(UIColor.init)
        }
    }

    @IBInspectable
    var borderWidth: CGFloat {
        set(width) {
            self.layer.borderWidth = width
        }

        get {
            return self.layer.borderWidth
        }
    }
}
