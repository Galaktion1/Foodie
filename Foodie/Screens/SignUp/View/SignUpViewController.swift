//
//  SignUpViewController.swift
//  Foodie
//
//  Created by Gaga Nizharadze on 09.07.22.
//

import UIKit

protocol SignUpViewControllerDelegate: AnyObject {
    func presentSuccesfullyRegistrationAlert()
}

class SignUpViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var whiteView: UIView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var signUpButtonOutlet: UIButton!
    
    // MARK: - Variables
    private let modify = UIElementModifications()
    private let viewModel = SignUpViewModel()
    weak var delegate: SignUpViewControllerDelegate?
    
    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.backgroundColor = UIColor(patternImage: UIImage(named: "img_background")!)
        
        whiteView.backgroundColor = .white.withAlphaComponent(0)
        modifyUIElements()
    }
    
    // MARK: - Actions
    @IBAction func signUpButton(_ sender: UIButton) {
        let result = viewModel.signUp(emailTextField: emailTextField, passwordTextField: passwordTextField, retypedPasswordTextField: confirmPasswordTextField, usernameTextField: usernameTextField)
        
        if result.isEmpty {
            navigationController?.popViewController(animated: true)
            delegate?.presentSuccesfullyRegistrationAlert()
            
        } else { self.presentAlert(title: "Error", message: result) }
        
        
    }
    
    // MARK: - Funcs
    private func modifyUIElements() {
        modify.modifyButtons(button: signUpButtonOutlet, color: CustomColors.specialOrangeColor!)
        
        modify.modifyTextFields(textField: usernameTextField)
        modify.modifyTextFields(textField: emailTextField)
        modify.modifyTextFields(textField: passwordTextField)
        modify.modifyTextFields(textField: confirmPasswordTextField)
        stackView.setCustomSpacing(45, after: confirmPasswordTextField)
    }
    
    private func checkIfUserCanSignUp() {
        navigationController?.popViewController(animated: true)
    }
    
    
    
}
