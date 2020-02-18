//
//  UseDefaultsContainer.swift
//  
//
//  Created by Юлия Воротченко on 02.01.2020.
//

import Foundation
import KeychainSwift

@propertyWrapper
class KeychainStorage {
    private let key: String
    private lazy var keychain = KeychainSwift()
    
    init(key: String) {
        self.key = key
    }
    
    var wrappedValue: String? {
        get {
            return self.keychain.get(self.key)
        }
        set {
            if let newValue = newValue {
                self.keychain.set(newValue, forKey: self.key)
            } else {
                self.keychain.delete(self.key)
            }
        }
    }
    
}

class KeyChainContainer {
    
    private enum Keys: String {
        case sessionID
    }
    
    @KeychainStorage(key: Keys.sessionID.rawValue)
    static var sessionID: String?
    
    static func unregister() {
        self.sessionID = ""
    }
}
