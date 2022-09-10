//
//  ViewController.swift
//  Foodie
//
//  Created by Gaga Nizharadze on 09.07.22.
//

import UIKit

class SignInViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var whiteView: UIView!
    @IBOutlet weak var logInButtonOutlet: UIButton!
    @IBOutlet weak var signUpButtonOutlet: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - Variables
    var coordinator: MainViewCoordinator?
    let viewModel = SignInViewModel()
    
    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.backgroundColor = UIColor(patternImage: UIImage(named: "img_background")!)
        
        whiteView.backgroundColor = .clear
        configureUIComponents()
        moveToMainScreen()
        presentErrorAlertIfNeed()
    }
    
    
    // MARK: - Actions
    @IBAction func loginButton(_ sender: UIButton) {
        viewModel.signIn(emailTextField: emailTextField, passwordTextField: passwordTextField)
    }
    
    @IBAction func signUpButtonAction(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    // MARK: - Funcs
    private func configureUIComponents() {
        
        logInButtonOutlet.modifyButtons(color: CustomColors.specialOrangeColor!)
        signUpButtonOutlet.modifyButtons(color: CustomColors.specialYellowColor!)
        
        emailTextField.modifyTextFields()
        passwordTextField.modifyTextFields()

    }
    
    private func moveToMainScreen() {
        viewModel.moveToMainScreen = { [weak self] in
            let nav = UINavigationController()
            self?.coordinator = MainViewCoordinator(navigationController: nav)
            self?.coordinator?.start()
            
            self?.view.window?.rootViewController = nav
            self?.view.window?.makeKeyAndVisible()
        }
    }
    
    private func presentErrorAlertIfNeed() {
        viewModel.presentErrorAlert = { [weak self] alertText in
            self?.presentAlert(title: "Error", message: alertText)
        }
    }
}


extension SignInViewController: SignUpViewControllerDelegate {
    func presentSuccesfullyRegistrationAlert() {
        self.presentAlert(title: "Congratulations", message: "You have succesfully registered 🎉")
    }
}