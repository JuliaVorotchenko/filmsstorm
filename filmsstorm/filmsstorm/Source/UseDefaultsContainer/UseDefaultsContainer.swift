//
//  UseDefaultsContainer.swift
//  
//
//  Created by Юлия Воротченко on 02.01.2020.
//

import Foundation


class UserDefaultsContainer {
    private enum UserDefaultsKey: String {
        case session
    }
    
    private static var defaults: UserDefaults {
        return UserDefaults.standard
    }
    
   
    static var session: String {
        get {
            return self.defaults.string(forKey: UserDefaultsKey.session.rawValue) ?? ""
        }
        set {
            self.defaults.set(newValue, forKey: UserDefaultsKey.session.rawValue)
            self.defaults.synchronize()
        }
    }
    
    static func registerDefaults() {
        let dictionary: [String: Any] = [UserDefaultsKey.session.rawValue: String()]
        self.defaults.register(defaults: dictionary)
    }
    
    static func unregister() {
        self.session = ""
    }
    
}
