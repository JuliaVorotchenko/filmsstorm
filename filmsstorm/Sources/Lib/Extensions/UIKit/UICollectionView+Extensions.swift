//
//  UICollectionView+Extensions.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 26.01.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit
import Foundation

extension UICollectionView {
    
    func register(_ anyClass: AnyClass) {
        let nib = UINib(nibName: F.toString(anyClass), bundle: nil)
        self.register(nib, forCellWithReuseIdentifier: F.toString(anyClass))
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(_ anyClass: AnyClass, for indexPath: IndexPath) -> T {
        let cell = self.dequeueReusableCell(withReuseIdentifier: F.toString(anyClass), for: indexPath)
        guard let cast = cell as? T else { fatalError("Dont find cell") }
        return cast
    }
    
    func registerHeader(_ anyClass: AnyClass) {
        let name = F.toString(anyClass)
        self.register(UINib(nibName: name, bundle: nil), forSupplementaryViewOfKind: name, withReuseIdentifier: name)
    }
}
