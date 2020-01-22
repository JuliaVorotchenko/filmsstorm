//
//  UIViewControllerextension.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 22.01.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit
// MARK: - protocol

protocol AlertPresetable {
    
}

// MARK: - Alert constants

struct  TextConstants {
    static let close = "Close"
    static let cancel = "Cancel"
    static let serverError = "Server Error"
    static let appError = "App error."
}

// MARK: - Protocol extension

extension UIViewController {
   
       // MARK: - Private typealias
       
       private typealias Text = TextConstants
       
       // MARK: - Methods
       
       func showAlert(title: String?,
                      message: String? = nil,
                      preferredStyle: UIAlertController.Style = .alert,
                      actions: [UIAlertAction]? = [UIAlertAction(title: Text.close,
                                                                 style: .destructive,
                                                                 handler: nil)]) {
           let alertController = UIAlertController(title: title,
                                                   message: message,
                                                   preferredStyle: preferredStyle)
           actions?.forEach { alertController.addAction($0) }
           self.present(alertController, animated: true, completion: nil)
       }
       
       func showErrorAlert(_ title: String?, error: Error?) {
           self.showAlert(title: title, message: error?.localizedDescription)
       }
       
    func showAppErrorAlert(_ error: AppError) {
        switch error {
        case .networkingError(let error):
            self.showAlert(title: Text.serverError, message: error.stringDescription)
        case .unowned(let error):
            self.showAlert(title: Text.appError, message: error.debugDescription)
        }
        
    }
    
       func showAlertWithAction(title: String?,
                                message: String?,
                                actionTitle: String?,
                                action: ((UIAlertAction) -> Void)?) {
           let alertAction = UIAlertAction(title: actionTitle,
                                           style: .default,
                                           handler: action)
           self.showAlert(title: title,
                          message: message,
                          actions: [alertAction])
       }
}
