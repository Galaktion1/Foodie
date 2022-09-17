//
//  SignUpConfigurator.swift
//  Foodie
//
//  Created by Gaga Nizharadze on 17.09.22.
//

import Foundation
import UIKit

enum SignUpConfigurator {
    static func configure() -> UIViewController {
        let firebaseManager = FirebaseManager()
        let worker = SignUpWorker(apiManager: firebaseManager)
        let presenter = SignUpPresenter()
        let interactor = SignUpInteractor(presenter: presenter, worker: worker)
        let router = SignUpRouter(dataStore: interactor)
        let sb = UIStoryboard(name: "SignIn&SignUp", bundle: Bundle.main)
        let viewController = sb.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        viewController.interactor = interactor 
        viewController.router = router
        
        presenter.viewController = viewController
        router.viewController = viewController
        
        return viewController
    }
}
