//
//  KeysManager.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 16.02.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

struct Keys: Decodable {
    let apiKey: String
    
    
    enum CodingKeys: String, CodingKey {
        case apiKey = "ApiKey"
    }
}

class KeysManager: NSObject {
    class func retreieveKeys() -> Keys {
        let bundle = Bundle(for: self.classForCoder())
        guard let url = bundle.url(forResource: "FilmsstormList", withExtension: ".plist") else { fatalError("Resourse doesn`t exist") }
        do {
            let data = try Data(contentsOf: url)
            let decoder = PropertyListDecoder()
            let plist = try decoder.decode([String: Keys].self, from: data)
            guard let keys = plist["Keys"] else { fatalError() }
            return keys
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}


struct AppKeyChain {
   static let sessionID = "sessionID"
   static let isLoggedIn = "isLoggedIn"
    static let password = "password"
    static let username = "username"
}
