//
//  User.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 20.07.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

class User {
    let id: String
    let username: String
    
    init(id: String, username: String) {
        self.id = id
        self.username = username
    }
    
    init(userEntity: UserEntity) {
        self.id = userEntity.id ?? ""
        self.username = userEntity.username ?? ""
    }
}
