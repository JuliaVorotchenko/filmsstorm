//
//  UIView+Keyboard.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 03.03.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

import UIKit

extension UIView {
    func hideKeyboardGeasture(_ cancelsTouches: Bool = false) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        tapGesture.cancelsTouchesInView = cancelsTouches
        self.addGestureRecognizer(tapGesture)
    }

    @objc private func hideKeyboard() {
        self.endEditing(true)
    }
}
