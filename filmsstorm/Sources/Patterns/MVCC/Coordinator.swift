//
//  Coordinator.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 06.01.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

/**
 MVCP+C is the base pattern on the project. Main actors are:
 - Model - Data container, persistance object;
 - View - Object to represent data on UI. You must inherite Cotroller type to use it as View.
 - Controller - Object, which acts as the intermediary between the application's view objects and its model objects.
 - Presenter - Object to incapsulate logic from visualization.
 - Coordinator - Entity, which allows to manage all controllers and sub-coordinators.
 
 Coordinator`s roles:
 - Incapsulates dependencies;
 - Provides dependency injection role;
 - Init presenters;
 - Init controllers with presenters;
 - Navigate controllers (show and hide instack, modally and in any other way);
 - Subscribes on controller`s events and react on events;
 - Show or hide sub-coordinators if needed.
 - Impl AppErrorPresentable to display app errors.
 
 Coordinator CAN NOT:
 - Save any controller as property;
 */
protocol Coordinator: AnyObject, AppEventSource {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get }
    func start()
}
