//
//  UIColor+Extensions.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 14.02.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

enum AppColor: String {
    case primary
    case primary200
    case primary500
    case primary800
    case secondary
    case surface
    case surfaceUp
    case background
    
    
}

extension UIColor {
    convenience init?(named name: AppColor) {
        self.init(named: name.rawValue)
    }
}
