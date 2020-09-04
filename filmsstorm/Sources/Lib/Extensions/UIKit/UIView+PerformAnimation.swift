//
//  UIView+PerformAnimation.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 03.03.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

extension UIView {
    func performAnimation(duration: TimeInterval = 0.2,
                          block: @escaping () -> Void,
                          completion: (() -> Void)? = nil
    ) {
        block()
        UIView.animate(withDuration: duration,
                       animations: { self.layoutIfNeeded() },
                       completion: { if $0 { completion?() } })
    }
}
