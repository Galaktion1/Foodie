//
//  SignInInteractor.swift
//  Foodie
//
//  Created by Gaga Nizharadze on 20.09.22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

protocol SignInBusinessLogic {
    func signInLogic(request: SignIn.Something.Request)
}

protocol SignInDataStore {
}

class SignInInteractor: SignInBusinessLogic, SignInDataStore {
    
    var presenter: SignInPresentationLogic
    var worker: SignInWorkerLogic
    
    
    init(presenter: SignInPresentationLogic, worker: SignInWorkerLogic) {
        self.presenter = presenter
        self.worker = worker
    }
    
    // MARK: try SignIn
    func signInLogic(request: SignIn.Something.Request) {
        worker.signIn(emailTextField: request.emailText, passwordTextField: request.passwordText) { [weak self] error in
            if let error = error {
                let response = SignIn.Something.Response(errorMessage: error)
                self?.presenter.presentAlert(response: response)
            } else { self?.presenter.prephareForMovingToMain() }
        }
    }
}