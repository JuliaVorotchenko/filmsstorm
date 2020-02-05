//
//  Functions.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 26.01.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

enum F {
    static func toString(_ anyClass: AnyClass) -> String {
        return .init(describing: anyClass)
    }
}
