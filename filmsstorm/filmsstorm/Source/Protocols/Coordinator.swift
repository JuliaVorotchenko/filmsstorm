//
//  Coordinator.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 29.12.2019.
//  Copyright © 2019 Alexander Andriushchenko. All rights reserved.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get }
    func start()
}
