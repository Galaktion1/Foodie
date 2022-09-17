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
    private let viewModel = SignUpViewModel()
    weak var delegate: SignUpViewControllerDelegate?
    static let identifier = String(describing: SignUpViewController.self)
    
    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.backgroundColor = UIColor(patternImage: CustomImages.backgroundImage!)
        self.hideKeyboardWhenTappedAround()
        handleSignUpActions()
    }
    
    override func viewDidLayoutSubviews() {
        whiteView.backgroundColor = .white.withAlphaComponent(0)
        modifyUIElements()
    }
    
    // MARK: - Actions
    @IBAction func signUpButton(_ sender: UIButton) {
        viewModel.signUpResponse(email: emailTextField.text, password: passwordTextField.text, retypedPassword: confirmPasswordTextField.text, username: usernameTextField.text)
    }
    
    // MARK: - Funcs
    private func handleSignUpActions() {
        viewModel.presentErrorAlert = { [weak self] error in
            self?.presentAlert(title: "Error", message: error)
        }
        
        viewModel.presentSuccessAlert = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
            self?.delegate?.presentSuccesfullyRegistrationAlert()
        }
    }
    
    private func modifyUIElements() {
        signUpButtonOutlet.modifyButtons(color: CustomColors.specialOrangeColor!)
        
        usernameTextField.modifyTextFields()
        emailTextField.modifyTextFields()
        passwordTextField.modifyTextFields()
        confirmPasswordTextField.modifyTextFields()
        stackView.setCustomSpacing(45, after: confirmPasswordTextField)
    }
    
    private func checkIfUserCanSignUp() {
        navigationController?.popViewController(animated: true)
    }
}
