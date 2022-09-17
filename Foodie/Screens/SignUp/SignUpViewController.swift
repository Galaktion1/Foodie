//
//  SignUpViewController.swift
//  Foodie
//
//  Created by Gaga Nizharadze on 17.09.22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol SignUpDisplayLogic: AnyObject {
    func displayErrorAlert()
    func displayPreviousVCWithSuccessAlert()
}

protocol SignUpViewControllerDelegate: AnyObject {
    func presentCGMessage()
}

class SignUpViewController: UIViewController, SignUpDisplayLogic {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var textFieldStackView: UIStackView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var signUpButtonOutlet: UIButton!
    
    weak var delegate: SignUpViewControllerDelegate?
    
    var interactor: SignUpBusinessLogic?
    var router: (NSObjectProtocol & SignUpRoutingLogic & SignUpDataPassing)?
    
    @IBAction func signUpButton(_ sender: UIButton) {
        interactorCall()
    }
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modifyUIElements()
        self.scrollView.backgroundColor = UIColor(patternImage: CustomImages.backgroundImage!)
        backView.backgroundColor = .clear
        self.hideKeyboardWhenTappedAround()
    }
    
    
    
    // MARK: Do something
    
    //@IBOutlet weak var nameTextField: UITextField!
    
    private func interactorCall() {
        let request = SignUp.Something.Request(email: emailTextField.text,
                                               password: passwordTextField.text,
                                               retypedPassword: confirmPasswordTextField.text,
                                               username: usernameTextField.text)
        interactor?.signUp(with: request)
    }
    
    
    func displayErrorAlert() {
        self.presentAlert(title: "Error", message: (router?.dataStore.errorMessage) ?? "")
    }
    
    func displayPreviousVCWithSuccessAlert() {
        router?.backToRootVC()
    }
    
    
    private func modifyUIElements() {
        signUpButtonOutlet.modifyButtons(color: CustomColors.specialOrangeColor!)
        
        usernameTextField.modifyTextFields()
        emailTextField.modifyTextFields()
        passwordTextField.modifyTextFields()
        confirmPasswordTextField.modifyTextFields()
        textFieldStackView.setCustomSpacing(45, after: confirmPasswordTextField)
    }
}