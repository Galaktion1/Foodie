//
//  SignInViewModel.swift
//  Foodie
//
//  Created by Gaga Nizharadze on 06.09.22.
//

import Foundation

class SignInViewModel {
    
    private let manager = FirebaseManager()
    var moveToMainScreen: (() -> Void)?
    var presentErrorAlert: ((String) -> Void)?
    
    func signIn(emailTextField: String?, passwordTextField: String?) {
        guard let email = emailTextField, let password = passwordTextField else {
            presentErrorAlert?("You should fill each textfield")
            return
        }
        
        if email.isEmpty || password.isEmpty {
            presentErrorAlert?("Fill text fields.")
        }
        
        else {
            manager.signIn(email: email,password: password) { [weak self] result in
                switch result {
                case .success(_):
                    self?.moveToMainScreen?()
                case.failure(let error):
                    self?.presentErrorAlert?(error.localizedDescription)
                }
            }
        }
    }
}

