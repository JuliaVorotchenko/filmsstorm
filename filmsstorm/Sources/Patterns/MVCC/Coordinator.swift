//
//  Coordinator.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 06.01.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

/**
 MVC+C is the base pattern on the project. Main actors are:
 - Model - Data container, persistance object;
 - View - Object to represent data on UI. You must inherite Cotroller type to use it as View.
 - Controller - Object, which acts as the intermediary between the application's view objects and its model objects.
 - Coordinator - Entity, which allows to manage all controllers and sub-coordinators.
 
 Coordinator`s roles:
 - Incapsulates dependencies;
 - Provides dependency injection role;
 - Init controllers;
 - Navigate controllers (show and hide instack, modally and in any other way);
 - Subscribes on controller`s events and react on events;
 - Show or hide sub-coordinators if needed.
 - Impl AppErrorPresentable to display app errors.
 
 Coordinator CAN NOT:
 - Save any controller as property;
 */
protocol Coordinator: AnyObject, AppErrorPresentable {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get }
    func start()
}

extension Coordinator {
    func addCoordinator(_ childCoordinator: Coordinator) {
        self.childCoordinators.append(childCoordinator)
    }
    
    func removeCoordinator(_ childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter { $0 !== childCoordinator }
    }

}
