//
//  AppErrorPresentable.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 22.01.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

/// Interfase to display app errors (AppError)
protocol AppErrorPresentable {
    func showAppErrorAlert(with error: AppError)
}

extension AppErrorPresentable where Self: Coordinator {
    
    func showAppErrorAlert(with error: AppError) {
        switch error {
        case .networkingError(let error):
            self.navigationController.showAlert(title: TextConstants.serverError, message: error.stringDescription)
        case .unowned(let error):
            self.navigationController.showAlert(title: TextConstants.appError, message: error.debugDescription)
        }
        
    }
}
