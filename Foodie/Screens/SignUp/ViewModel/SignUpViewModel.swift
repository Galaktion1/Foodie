//
//  SignUpViewModel.swift
//  Foodie
//
//  Created by Gaga Nizharadze on 06.09.22.
//

import Foundation

class SignUpViewModel {

    private let manager = FirebaseManager()
    private let validationService = ValidationService()

    var presentErrorAlert: ((String) -> ())?
    var presentSuccessAlert: (() -> ())?

    private func signUp(email: String?, password: String?, retypedPassword: String?, username: String?) -> SignUpResponses {
        guard let password = password, let email = email, let retypedPass = retypedPassword, let username = username else {
            return .emptyTextField
        }

        if password.isEmpty || email.isEmpty || retypedPass.isEmpty || username.isEmpty {
            return .emptyTextField
        }
        if password != retypedPass {
            return .unmatchPassword
        } else if !validationService.isValidPassword(password) {
            return .shortPassword
        }
        else if !validationService.isValidEmail(email) {
            return .invalidMail
        }
        else {
            manager.signUp(with: email, password: password, username: username) { result in
                print(result)
            }
        }
        return .success
    }

    func signUpResponse(email: String?, password: String?, retypedPassword: String?, username: String?) {
        let response = signUp(email: email, password: password, retypedPassword: retypedPassword, username: username)

        switch response {
        case .success:
            presentSuccessAlert?()
        default:
            presentErrorAlert?(response.rawValue)
        }
    }

}


enum SignUpResponses: String {
    case emptyTextField = "You have to fill each text field."
    case unmatchPassword = "passwords don't match"
    case shortPassword = "password length should be more than 6 characters"
    case invalidMail = "Invalid Email"
    case success
}
