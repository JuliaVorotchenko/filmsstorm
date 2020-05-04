//
//  File.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 04.05.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation
import RxSwift

class LoginViewModel {
    
    let usernameTextPublSubj = PublishSubject<String>()
    let passwordTextPublSubj = PublishSubject<String>()
    let validation = Validator()
    
    func isValid() -> Observable<Bool> {
        Observable.combineLatest(usernameTextPublSubj.asObservable().startWith(" "),
                                 passwordTextPublSubj.asObservable().startWith(" "))
            .map { username, password in
                return self.validation.validateUsername(username: username) && self.validation.validatePassword(password: password)
        }.startWith(false)
    }
}
