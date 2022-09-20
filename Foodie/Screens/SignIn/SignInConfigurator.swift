//
//  SignInConfigurator.swift
//  Foodie
//
//  Created by Gaga Nizharadze on 20.09.22.
//

import Foundation

import Foundation
import UIKit

enum SignInConfigurator {
    static func configure() -> UINavigationController {
        let firebaseManager = FirebaseManager()
        let worker = SignInWorker(apiManager: firebaseManager)
        let presenter = SignInPresenter()
        let interactor = SignInInteractor(presenter: presenter, worker: worker)
        let router = SignInRouter(dataStore: interactor)
        let sb = UIStoryboard(name: "SignIn&SignUp", bundle: Bundle.main)
        let viewController = sb.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        viewController.interactor = interactor
        viewController.router = router
        
        presenter.viewController = viewController
        router.viewController = viewController
        
        return UINavigationController(rootViewController: viewController)
    }
}
