//
//  OptionalExtension.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 17.01.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

extension Optional {
    public func `do`(_ action: (Wrapped) -> Void) {
        self.map(action)
    }
}
