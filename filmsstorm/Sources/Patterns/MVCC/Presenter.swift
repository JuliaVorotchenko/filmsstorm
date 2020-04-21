//
//  Presenter.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 05.03.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

/**
Due to this realization of MVC + C pattern, every controller must have its own Presenter.
This protocol defines base behaviour for all Controllers.

Presenter's roles:
- provide modified and prepeared data to display on Controller
- generate events for coordinator about user`s action;
- incapsulate all actions like requests to internet or modifications of model layer

Presenters CAN NOT:
- import UIKit
- save Controller or any other View as property
- modify or change Controller's state directly
*/
protocol Presenter: AnyObject, EventSourse {
    
}
