//
//  Presenter.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 05.03.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

/**
 
 Presenter is responsible for app`s buisness logic realization

 - generate events for coordinator about user`s action;
 - EventSourse to provide events for coordinator;
 - retrieves data from model;
 - formates data for ViewController.

 */

protocol Presenter: AnyObject, EventSourse {
    
}
