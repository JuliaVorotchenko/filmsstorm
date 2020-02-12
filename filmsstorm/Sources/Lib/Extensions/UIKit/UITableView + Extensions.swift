//
//  UITableView + Extensions.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 12.02.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit
import Foundation

extension UITableView {
    
    func register(_ anyClass: AnyClass) {
        let nib = UINib(nibName: F.toString(anyClass), bundle: nil)
        self.register(nib, forCellReuseIdentifier: F.toString(anyClass))
    }
    
    func dequeueReusableCell<T: UITableViewCell>(_ anyClass: AnyClass, for indexPath: IndexPath) -> T {
        let cell = self.dequeueReusableCell(withIdentifier: F.toString(anyClass), for: indexPath)
        guard let cast = cell as? T else { fatalError("Dont find cell") }
        return cast
    }
}
