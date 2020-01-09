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
        case token
    }
    
    private static var defaults: UserDefaults {
        return UserDefaults.standard
    }
    
    static var token: String {
        get {
                   return self.defaults.string(forKey: UserDefaultsKey.token.rawValue) ?? ""
               }
               set {
                   self.defaults.set(newValue, forKey: UserDefaultsKey.token.rawValue)
                   self.defaults.synchronize()
               }
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
        let sessionDictionary: [String: Any] = [UserDefaultsKey.session.rawValue: String()]
        let tokenDictionary: [String: Any] = [UserDefaultsKey.token.rawValue: String()]
        self.defaults.register(defaults: sessionDictionary)
        self.defaults.register(defaults: tokenDictionary)
    }
    
    static func unregister() {
        self.session = ""
        self.token = ""
    }
    
}
