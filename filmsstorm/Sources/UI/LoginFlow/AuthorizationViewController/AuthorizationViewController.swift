//
//  AuthorizationViewController.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 29.12.2019.
//  Copyright © 2019 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class AuthorizationViewController<T: AuthorizationPresenter>: UIViewController, Controller, ActivityViewPresenter {
 
    // MARK: - Subtypes

    typealias RootViewType = AuthorizationView
    typealias Service = T
    
    // MARK: - Properties
    
    let loadingView: ActivityView = .init()
    
    // MARK: - Private properties

    internal let presenter: Service
    
    // MARK: - Init and deinit
    
    deinit {
        self.hideActivity()
        F.Log(F.toString(Self.self))
    }
    
    required init(_ presentation: Service) {
        self.presenter = presentation
        super.init(nibName: F.nibNamefor(Self.self), bundle: nil)
        self.setupActivity(with: self.presenter)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - IBAction
   
    @IBAction func buttonTapped(_ sender: Any) {
        guard let username = self.rootView?.usernameTextField.text,
            let password = self.rootView?.passwordTextField.text  else { return }
        self.presenter.getToken(username: username, password: password)
    }
    
    // MARK: - Private methods
   
    private func configureActivity(_ activity: ActivityState) {
        switch activity {
        case .show:
            self.showActivity()
        case .hide:
            self.hideActivity()
        }
    }
    
    private func setupActivity(with presenter: Service) {
        presenter.showActivity = { [weak self] in self?.configureActivity($0)}
    }
    
}
