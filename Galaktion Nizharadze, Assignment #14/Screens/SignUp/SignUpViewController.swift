//
//  SignUpViewController.swift
//  Galaktion Nizharadze, Assignment #14
//
//  Created by Gaga Nizharadze on 09.07.22.
//

import UIKit


class SignUpViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var whiteView: UIView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var signUpButtonOutlet: UIButton!
    
    private let modify = UIElementModifications()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.backgroundColor = UIColor(patternImage: UIImage(named: "img_background")!)
        
        whiteView.backgroundColor = .white.withAlphaComponent(0)
        modifyUIElements()
    }
    
    @IBAction func signUpButton(_ sender: UIButton) {
        checkIfUserCanSignUp()
    }
    
    private func modifyUIElements() {
        modify.modifyButtons(button: signUpButtonOutlet, colorString: "specialOrange")
        
        modify.modifyTextFields(textField: usernameTextField)
        modify.modifyTextFields(textField: emailTextField)
        modify.modifyTextFields(textField: passwordTextField)
        modify.modifyTextFields(textField: confirmPasswordTextField)
        stackView.setCustomSpacing(45, after: confirmPasswordTextField)
    }
    
    private func checkIfUserCanSignUp() {
        navigationController?.popViewController(animated: true)
    }
    
    func isPasswordValid(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$")
        return passwordTest.evaluate(with: password)
    }
    
}
