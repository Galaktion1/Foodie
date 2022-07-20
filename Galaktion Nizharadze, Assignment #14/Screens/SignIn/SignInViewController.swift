//
//  ViewController.swift
//  Galaktion Nizharadze, Assignment #14
//
//  Created by Gaga Nizharadze on 09.07.22.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var whiteView: UIView!
    @IBOutlet weak var logInButtonOutlet: UIButton!
    @IBOutlet weak var signUpButtonOutlet: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var email: String!
    var password: String!
    var userName: String!
    
    private let modifications = UIElementModifications()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.backgroundColor = UIColor(patternImage: UIImage(named: "img_background")!)
        
        whiteView.backgroundColor = .white.withAlphaComponent(0)
        configureUIComponents()
        
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
       
        if true {
          
            let sb = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vc = sb.instantiateViewController(withIdentifier: "MainViewController")
            
            self.view.window?.rootViewController = vc
            self.view.window?.makeKeyAndVisible()
            
   
        }
        
        else {
            self.presentAlert(title: "Error", message: "incorrect credentials")
        }
    }
    
    
    private func configureUIComponents() {
        modifications.modifyButtons(button: logInButtonOutlet, colorString: "specialOrange")
        modifications.modifyButtons(button: signUpButtonOutlet, colorString: "specialYellow")
        
        modifications.modifyTextFields(textField: emailTextField)
        modifications.modifyTextFields(textField: passwordTextField)
    }
    
}


