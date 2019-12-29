//
//  AuthorizationViewController.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 29.12.2019.
//  Copyright © 2019 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class AuthorizationViewController: UIViewController {
    @IBOutlet var rootView: AuthorizationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
   
    @IBAction func buttonTapped(_ sender: Any) {
        let vc = SessionIDViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
