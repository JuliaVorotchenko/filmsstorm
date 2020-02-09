//
//  AboutViewController.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 09.02.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController, ActivityViewPresenter {

    // MARK: - Subtypes
   
    typealias RootViewType = AboutView
    
    // MARK: - Public Properties
    
    let loadingView = ActivityView()
    
    // MARK: - Private properties
    private let networking: NetworkManager
    
    // MARK: - IBActions
    
    init(networking: NetworkManager) {
        self.networking = networking
        super.init(nibName: F.toString(type(of: self)), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print(Self.self)
    }
    
    // MARK: - VC lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
