//
//  Validaion.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 04.05.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

class Validator {
    
    func validateUsername(username: String) -> Bool {
        
        let nameRegex = "^\\w{3,15}$"
        let trimmedString = username.trimmingCharacters(in: .whitespaces)
        let validateName = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        let isValidateName = validateName.evaluate(with: trimmedString)
        return isValidateName
    }
    
    public func validatePassword(password: String) -> Bool {
       
       let passwordRegex = "^\\w{4,}$"
       let trimmedString = password.trimmingCharacters(in: .whitespaces)
       let validatePassord = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
       let isvalidatePass = validatePassord.evaluate(with: trimmedString)
       return isvalidatePass
    }
}
