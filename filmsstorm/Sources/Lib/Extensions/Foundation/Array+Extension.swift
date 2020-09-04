//
//  Array+Extension.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 03.03.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    @discardableResult
    mutating func remove(object: Element) -> Int? {
        let index = self.firstIndex(of: object)
        if let index = index {
            self.remove(at: index)
        }
        return index
    }
    
    mutating func replace(object: Element, at index: Int) {
        self.replaceSubrange(index...index, with: [object])
    }
    
    mutating func replace(object: Element, where whereCondition: (Element, Element) -> Bool) {
        self.firstIndex { whereCondition(object, $0) }.map {
            self.replace(object: object, at: $0)
        }
    }
}

public extension Array where Element: Hashable {
     func uniqued() -> [Element] {
         var seen = Set<Element>()
         return filter { seen.insert($0).inserted }
     }
 }
