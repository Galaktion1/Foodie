//
//  SignInPresenter.swift
//  Foodie
//
//  Created by Gaga Nizharadze on 20.09.22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol SignInPresentationLogic {
    func prephareForMovingToMain()
    func presentAlert(response: SignIn.Something.Response)
}

class SignInPresenter: SignInPresentationLogic {
    weak var viewController: SignInDisplayLogic?
    
    func presentAlert(response: SignIn.Something.Response) {
        viewController?.displayErrorAlert(with: response)
    }
    
    func prephareForMovingToMain() {
        viewController?.displayMain()
    }
}
