//
//  UserDefaultsContainer.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 06.04.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

@propertyWrapper
final class UserDefaultsStorage<Value> {
    
    // MARK: - Properties
    
    private var defaults: UserDefaults {
           return UserDefaults.standard
       }
    private let value: Value
    private let key: String
    
    // MARK: - Init
    
    init(key: String, value: Value) {
        self.key = key
        self.value = value
    }

    var wrappedValue: Value {
        get {
           return self.defaults.object(forKey: self.key) as? Value ?? self.value
        }
        set {
            self.defaults.set(newValue, forKey: self.key)
            self.defaults.synchronize()
        }
    }
}

final class UserMoviesContainer {
    
    // MARK: - Subtypes
    
    private enum UserDefaultsKey: String {
        case watchlist = "movies_watchlist"
        case favorites = "movies_favorites_list"
    }
    
    @UserDefaultsStorage(key: UserDefaultsKey.watchlist.rawValue, value: [])
    static var watchlistIDs: [Int]
    
    @UserDefaultsStorage(key: UserDefaultsKey.favorites.rawValue, value: [])
    static var favoritesIDs: [Int]
    
    static func unregister() {
        self.watchlistIDs = []
        self.favoritesIDs = []
    }
}

final class UserShowsContainer {
    
    // MARK: - Subtypes
    
    private enum UserDefaultsKey: String {
        case watchlist = "shows_watchlist"
        case favorites = "shows_favorites_list"
    }
    
    @UserDefaultsStorage(key: UserDefaultsKey.watchlist.rawValue, value: [])
    static var watchlistIDs: [Int]
    
    @UserDefaultsStorage(key: UserDefaultsKey.favorites.rawValue, value: [])
    static var favoritesIDs: [Int]
    
    static func unregister() {
        self.watchlistIDs = []
        self.favoritesIDs = []
    }
}

