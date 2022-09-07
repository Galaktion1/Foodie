//
//  SignUpViewModel.swift
//  Foodie
//
//  Created by Gaga Nizharadze on 06.09.22.
//

import Foundation
import UIKit

class SignUpViewModel {
    
    private let manager = FirebaseManager()
    
    func signUp(emailTextField: UITextField, passwordTextField: UITextField, retypedPasswordTextField: UITextField, usernameTextField: UITextField) -> String {
        guard let password = passwordTextField.text, let email = emailTextField.text, let retypedPass = retypedPasswordTextField.text, let username = usernameTextField.text else {
            return "You have to fill each text field."
        }
        
        if password.isEmpty || email.isEmpty || retypedPass.isEmpty || username.isEmpty {
            return "You have to fill each text field."
        }
        if password != retypedPass {
            return "passwords don't match"
        } else if !manager.isValidPassword(password) {
            return "password length should be more than 6 characters"
        }
        else if !manager.isValidEmail(email) {
            return "Invalid Email"
        }
        else {
            manager.signUp(with: email, password: password, username: username) { result in
                print(result)
            }
        }
        return ""
           
    }
}
