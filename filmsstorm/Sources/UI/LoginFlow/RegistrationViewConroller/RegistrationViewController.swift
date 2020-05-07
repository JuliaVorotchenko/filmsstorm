//
//  RegistrationViewController.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 07.05.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class RegistrationViewController<T: RegistrationPresenter>: UIViewController, Controller, ActivityViewPresenter {
   
    // MARK: - Subtypes
    
    typealias Service = T
    typealias RootViewType = RegistrationView
    
// MARK: - Properties
    
    var loadingView: ActivityView = .init()
    let presenter: Service
   
    // MARK: - Init and deinit
    
    deinit {
        self.hideActivity()
        F.Log(F.toString(Self.self))
    }
    
    required init(_ presentation: Service) {
        self.presenter = presentation
        super.init(nibName: F.nibNamefor(Self.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewController LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    

}
