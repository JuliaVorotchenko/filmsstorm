//
//  String+Extension.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 13.04.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

extension String {
  func toDate(withFormat format: String = "yyyy-MM-dd") -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    guard let date = dateFormatter.date(from: self) else {
      preconditionFailure("Take a look to your format")
    }
    return date
  }
}
