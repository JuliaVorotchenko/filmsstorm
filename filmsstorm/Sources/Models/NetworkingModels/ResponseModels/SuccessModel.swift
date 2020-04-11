//
//  SuccessModel.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 11.04.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

struct SuccessModel: Codable {
    let statusCode: Int?
    let statusMessage: String?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}
