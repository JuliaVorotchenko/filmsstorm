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
        case username
        case password
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
    
    static var username: String {
        get {
            return self.defaults.string(forKey: UserDefaultsKey.username.rawValue) ?? ""
        }
        set {
            self.defaults.set(newValue, forKey: UserDefaultsKey.username.rawValue)
            self.defaults.synchronize()
        }
    }
    
    static var password: String {
        get {
            return self.defaults.string(forKey: UserDefaultsKey.password.rawValue) ?? ""
        }
        set {
            self.defaults.set(newValue, forKey: UserDefaultsKey.password.rawValue)
            self.defaults.synchronize()
        }
    }
    
    static func registerDefaults() {
        let sessionDictionary: [String: Any] = [UserDefaultsKey.session.rawValue: String()]
        let tokenDictionary: [String: Any] = [UserDefaultsKey.token.rawValue: String()]
        let usenameDictionary: [String: Any] = [UserDefaultsKey.username.rawValue: String()]
        let passwordDictionary: [String: Any] = [UserDefaultsKey.password.rawValue: String()]
        self.defaults.register(defaults: sessionDictionary)
        self.defaults.register(defaults: tokenDictionary)
        self.defaults.register(defaults: usenameDictionary)
        self.defaults.register(defaults: passwordDictionary)
    }
    
    static func unregister() {
        self.session = ""
        self.token = ""
    }
    
}
