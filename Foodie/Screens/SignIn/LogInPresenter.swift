//
//  LogInPresenter.swift
//  Foodie
//
//  Created by Gaga Nizharadze on 16.09.22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol LogInPresentationLogic {
    func presentSomething(response: LogIn.Something.Response)
    func prephareForMovingToMain()
    func prephareForAlertPresentation(response: LogIn.Something.Response)
}

class LogInPresenter: LogInPresentationLogic {
    weak var viewController: LogInDisplayLogic?
    
    
    func prephareForAlertPresentation(response: LogIn.Something.Response) {
        viewController?.displayErrorAlert(with: response)
    }
    
    func prephareForMovingToMain() {
        viewController?.displayMain()
    }
    // MARK: Do something
    
    func presentSomething(response: LogIn.Something.Response) {
        
    }
    
}