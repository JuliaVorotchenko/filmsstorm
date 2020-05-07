//
//  RegistrationViewController.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 07.05.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit
import WebKit

class RegistrationViewController<T: RegistrationPresenter>: UIViewController, Controller, ActivityViewPresenter, WKUIDelegate {
    
    // MARK: - Subtypes
    
    typealias Service = T
    typealias RootViewType = RegistrationView
    
    // MARK: - Properties
    
    var loadingView: ActivityView = .init()
    let presenter: Service
    var webView: WKWebView!
    
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
    
    override func loadView() {
        self.webViewConfiguration()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.loadSingUpURL()
    }
    
    private func webViewConfiguration() {
        let webConfiguration = WKWebViewConfiguration()
        self.webView = WKWebView(frame: .zero, configuration: webConfiguration)
        self.webView.uiDelegate = self
        self.view = webView
    }
    
    private func loadSingUpURL() {
        let myURL = URL(string: "https://www.themoviedb.org/account/signup")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
}
