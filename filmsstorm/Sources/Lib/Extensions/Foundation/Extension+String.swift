//
//  Extension+String.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 03.03.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

extension String {
    
    var url: URL? { return URL(string: self) }
    var fileURL: URL? { return URL(fileURLWithPath: self) }
    var int: Int? { return Int(self) }
    
    var notEmpty: Bool { return !self.isEmpty }
    var pathExtension: String { return (self as NSString).pathExtension }
    
    func splitedLast(by separator: String.Element) -> Substring? {
        return self.split(separator: separator).last
    }
    
    func framed(with mark: String) -> String {
        return mark + self + mark
    }
}

extension Substring {
    
    var int: Int? { return Int(self) }
}
