//
//  Dictionary+Extensions.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 03.03.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

extension Dictionary {
    init(_ elements: [Element]) {
        self.init()
        for (k, v) in elements {
            self[k] = v
        }
    }
    
    var allKeys: [Key] { Array(self.keys) }
    
    var allValues: [Value] { Array(self.values) }
    
    @discardableResult
    func append(_ value: Dictionary.Value,
                forKey key: Dictionary.Key) -> [Dictionary.Key: Dictionary.Value] {
        var tmp = self
        tmp.updateValue(value, forKey: key)
        return tmp
    }
}
