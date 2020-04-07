//
//  UserDefaultsContainer.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 06.04.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

class UserDefaultsContainer {
    
    private enum UserDefaultsKey: String {
        case watchlist
        case favorites
    }
    
    private static var defaults: UserDefaults {
        return UserDefaults.standard
    }
    
    static var watchlist: [Int] {
        get {
            return self.defaults.array(forKey: UserDefaultsKey.watchlist.rawValue) as? [Int] ?? [Int]()
        }
        set {
            self.defaults.set(newValue.uniqued(), forKey: UserDefaultsKey.watchlist.rawValue)
            self.defaults.synchronize()
        }
    }
    
    static var favorites: [Int] {
        get {
            return self.defaults.array(forKey: UserDefaultsKey.favorites.rawValue) as? [Int] ?? [Int]()
        }
        set {
            self.defaults.set(newValue.uniqued(), forKey: UserDefaultsKey.favorites.rawValue)
            self.defaults.synchronize()
        }
    }
    
    static func registerDefaults() {
        let favDictionary: [String: Any] = [UserDefaultsKey.watchlist.rawValue: [Int]()]
        let watchDictionary: [String: Any] = [UserDefaultsKey.favorites.rawValue: [Int]()]
        self.defaults.register(defaults: favDictionary)
        self.defaults.register(defaults: watchDictionary)
    }
    
    static func unregister() {
        self.watchlist = []
        self.favorites = []
    }
    
}

